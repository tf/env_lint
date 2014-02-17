require 'spec_helper'

module EnvLint
  describe Verification do
    describe '#complete?' do
      it 'passes if all non optional variables are present in the env' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        env = Environment.new(['APP'])
        verification = Verification.new(dot_env_file)

        expect {
          verification.complete?(env)
        }.not_to raise_error
      end

      it 'raises an exception if a non optional variable is not defined' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        env = Environment.new([])
        verification = Verification.new(dot_env_file)

        expect {
          verification.complete?(env)
        }.to raise_error(MissingVariable)
      end

      it 'passes if optional variable is not defined' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP', '', true)])
        env = Environment.new([])
        verification = Verification.new(dot_env_file)

        expect {
          verification.complete?(env)
        }.not_to raise_error
      end
    end

    describe '#all_known?' do
      it 'passes if all variables of the env are known' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        env = Environment.new(['APP'])
        verification = Verification.new(dot_env_file)

        expect {
          verification.all_known?(env)
        }.not_to raise_error
      end

      it 'raises an exception if a variable is unknown' do
        dot_env_file = DotEnvFile.new('.env.example', [])
        env = Environment.new(['OTHER'])
        verification = Verification.new(dot_env_file)

        expect {
          verification.all_known?(env)
        }.to raise_error(UnknownVariable)
      end
    end
  end
end
