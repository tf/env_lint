require 'spec_helper'
require 'fileutils'

describe EnvLint do
  SANDBOX_DIR = File.join(File.dirname(__FILE__), 'tmp')

  around do |example|
    clean_up_sandbox
    in_sandbox { example.run }
  end

  describe '.verify_hash' do
    it 'passes when hash is complete' do
      File.write('.env.example', <<-END)
        APP=myapp
      END

      expect {
        EnvLint.verify_hash('.env.example', {'APP' => 'some name'})
      }.not_to raise_error
    end

    it 'fails when hash is missing non optional variable' do
      File.write('.env.example', <<-END)
        APP=myapp
      END

      expect {
        EnvLint.verify_hash('.env.example', {'OTHER' => 'other'})
      }.to raise_error(EnvLint::MissingVariables)
    end
  end

  describe '.verify_args' do
    it 'passes when all args are known' do
      File.write('.env.example', <<-END)
        APP=myapp
        OTHER=other
      END

      expect {
        EnvLint.verify_args('.env.example', ['APP=name'])
      }.not_to raise_error
    end

    it 'fails when there are unknown args' do
      File.write('.env.example', <<-END)
        APP=myapp
      END

      expect {
        EnvLint.verify_args('.env.example', ['OTHER=name'])
      }.to raise_error(EnvLint::UnknownVariables)
    end
  end

  describe '.verify_export_output' do
    it 'passes when the env is complete' do
      File.write('.env.example', <<-END)
        APP=myapp
      END
      export_output = <<-END
        declare -x APP="myapp"
        declare -x OTHER="other"
      END

      expect {
        EnvLint.verify_export_output('.env.example', export_output)
      }.not_to raise_error
    end

    it 'fails when the env is missing non optional variable' do
      File.write('.env.example', <<-END)
        APP=myapp
      END
      export_output = <<-END
        declare -x OTHER="other"
      END

      expect {
        EnvLint.verify_export_output('.env.example', export_output)
      }.to raise_error(EnvLint::MissingVariables)
    end
  end

  private

  def clean_up_sandbox
    FileUtils.rm_rf(SANDBOX_DIR)
    FileUtils.mkdir_p(SANDBOX_DIR)
  end

  def in_sandbox(&block)
    Dir.chdir(SANDBOX_DIR, &block)
  end
end
