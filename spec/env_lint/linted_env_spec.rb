require 'spec_helper'

module EnvLint
  describe LintedEnv do
    describe '#fetch' do
      it 'returns value from env for known variable' do
        env = {'APP' => 'myapp'}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect(linted_env.fetch('APP')).to eq('myapp')
      end

      it 'translates symbols to uppercase strings' do
        env = {'APP_NAME' => 'myapp'}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP_NAME')])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect(linted_env.fetch(:app_name)).to eq('myapp')
      end

      it 'raises exception for unknown variable' do
        env = {'APP' => 'myapp'}
        dot_env_file = DotEnvFile.new('.env.example', [])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect {
          linted_env.fetch('APP')
        }.to raise_error(UnknownVariable)
      end

      it 'raises exception for undefined variable' do
        env = {}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect {
          linted_env.fetch('APP')
        }.to raise_error(MissingVariable)
      end

      it 'returns default value for undefined variable' do
        env = {}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect(linted_env.fetch('APP', 'default')).to eq('default')
      end

      it 'allows default value to be false' do
        env = {}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect(linted_env.fetch('APP', false)).to eq(false)
      end

      it 'returns default from block for undefined variable' do
        env = {}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP')])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect(linted_env.fetch('APP') { 'default' }).to eq('default')
      end

      it 'raises exception if optional variable is used without default' do
        env = {'APP' => 'myapp'}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP', '', true)])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect {
          linted_env.fetch('APP')
        }.to raise_error(DefaultValueRequiredForOptionalVariable)
      end

      it 'allows to use optional variable with default value' do
        env = {'APP' => 'myapp'}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP', '', true)])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect(linted_env.fetch('APP', 'default')).to eq('myapp')
      end

      it 'allows to use optional variable with block' do
        env = {'APP' => 'myapp'}
        dot_env_file = DotEnvFile.new('.env.example', [Variable.new('APP', '', true)])
        linted_env = LintedEnv.new(env, dot_env_file)

        expect(linted_env.fetch('APP') { 'block' }).to eq('myapp')
      end
    end
  end
end
