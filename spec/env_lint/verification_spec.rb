require 'spec_helper'

module EnvLint
  describe Verification do
    describe '#find_missing' do
      it 'passes if all non optional variables are present in the env' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        env = Environment.new(['APP'])
        verification = Verification.new(dot_env_file)

        expect(verification.find_missing(env)).to be_empty
      end

      it 'raises an exception listing undefined non optional variables' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP'), Variable.new('URL'), Variable.new('OTHER')])
        env = Environment.new(['APP'])
        verification = Verification.new(dot_env_file)

        missing_variables = verification.find_missing(env)

        expect(missing_variables.size).to eq(2)
        expect(missing_variables.first.name).to eq('URL')
        expect(missing_variables.last.name).to eq('OTHER')
      end

      it 'passes if optional variable is not defined' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP', '', true)])
        env = Environment.new([])
        verification = Verification.new(dot_env_file)

        expect(verification.find_missing(env)).to be_empty
      end
    end

    describe '#find_unknown' do
      it 'passes if all variables of the env are known' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        env = Environment.new(['APP'])
        verification = Verification.new(dot_env_file)

        expect(verification.find_unknown(env)).to be_empty
      end

      it 'raises an exception if a variable is unknown' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        env = Environment.new(['APP', 'UNKNOWN', 'OTHER'])
        verification = Verification.new(dot_env_file)

        unknown_variables = verification.find_unknown(env)

        expect(unknown_variables.size).to eq(2)
        expect(unknown_variables.first).to eq('UNKNOWN')
        expect(unknown_variables.last).to eq('OTHER')
      end
    end
  end
end
