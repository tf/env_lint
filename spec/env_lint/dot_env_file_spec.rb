require 'spec_helper'

module EnvLint
  describe DotEnvFile do
    describe '#verify_no_missing' do
      it 'passes if all non optional variables are present in the env' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])

        expect {
          dot_env_file.verify_no_missing(['APP'])
        }.not_to raise_error
      end

      it 'raises an exception listing undefined non optional variables' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP'), Variable.new('URL')])

        expect {
          dot_env_file.verify_no_missing(['APP'])
        }.to raise_error(MissingVariables)
      end

      it 'lists undefined non optional variables in exception' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP'), Variable.new('URL'), Variable.new('OTHER')])

        begin
          dot_env_file.verify_no_missing(['APP'])
        rescue MissingVariables => e
          expect(e.missing_variables.size).to eq(2)
          expect(e.missing_variables.first.name).to eq('URL')
          expect(e.missing_variables.last.name).to eq('OTHER')
        end
      end

      it 'passes if optional variable is not defined' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP', '', true)])

        expect {
          dot_env_file.verify_no_missing([''])
        }.not_to raise_error
      end
    end

    describe '#verfy_no_unknown' do
      it 'passes if all variables of the env are known' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])

        expect {
          dot_env_file.verify_no_unknown(['APP'])
        }.not_to raise_error
      end

      it 'raises an exception if a variable is unknown' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])

        expect {
          dot_env_file.verify_no_unknown(['APP', 'UNKNOWN', 'OTHER'])
        }.to raise_error(UnknownVariables)
      end

      it 'lists unknown variables in exception' do
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])

        begin
          dot_env_file.verify_no_unknown(['APP', 'UNKNOWN', 'OTHER'])
        rescue UnknownVariables => e
          expect(e.unknown_variables.size).to eq(2)
          expect(e.unknown_variables.first).to eq('UNKNOWN')
          expect(e.unknown_variables.last).to eq('OTHER')
        end
      end
    end
  end
end
