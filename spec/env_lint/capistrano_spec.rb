require 'spec_helper'
require 'env_lint/capistrano'

module EnvLint
  describe Capistrano do
    let :config do
      ::Capistrano::Configuration.new
    end

    let :namespace do
      config.env
    end

    let :formatter do
      instance_double(Formatter, ok: true, missing_variables: true, unknown_variables: true, error: true)
    end

    before do
      config.set(:application_user, 'myapp')

      EnvLint::Capistrano.load_into(config, formatter)
    end

    describe 'env:lint' do
      it 'calls verify_export_output with result of capute' do
        config.set(:env_definition_file, '.env.example')

        allow(namespace).to receive(:capture).and_return('declare -x APP=1')
        expect(EnvLint).to receive(:verify_export_output).with('.env.example', 'declare -x APP=1')

        config.find_and_execute_task('env:lint')
      end

      it 'passes missing variables to formatter and aborts' do
        dot_env_file = {}
        variables = ['APP']

        allow(namespace).to receive(:capture).and_return('declare -x APP=1')
        allow(EnvLint).to receive(:verify_export_output).and_raise(MissingVariables.new(dot_env_file, variables))
        expect(namespace).to receive(:abort)
        expect(formatter).to receive(:missing_variables).with(dot_env_file, variables)

        config.find_and_execute_task('env:lint')
      end

      it 'passes error message to formatter and aborts' do
        dot_env_file = {}
        variables = ['APP']

        allow(namespace).to receive(:capture).and_return('declare -x APP=1')
        allow(EnvLint).to receive(:verify_export_output).and_raise(Error.new('message'))
        expect(namespace).to receive(:abort)
        expect(formatter).to receive(:error).with('message')

        config.find_and_execute_task('env:lint')
      end
    end

    describe 'env:lint_args' do
      it 'calls verify_args with result of capute' do
        config.set(:env_definition_file, '.env.example')

        allow(namespace).to receive(:env_args).and_return(['APP=1'])
        expect(EnvLint).to receive(:verify_args).with('.env.example', ['APP=1'])

        config.find_and_execute_task('env:lint_args')
      end

      it 'passes missing variables to formatter and aborts' do
        dot_env_file = {}
        variables = ['APP']

        allow(namespace).to receive(:env_args).and_return(['APP=1'])
        allow(EnvLint).to receive(:verify_args).and_raise(UnknownVariables.new(dot_env_file, variables))
        expect(namespace).to receive(:abort)
        expect(formatter).to receive(:unknown_variables).with(dot_env_file, variables)

        config.find_and_execute_task('env:lint_args')
      end

      it 'passes error message to formatter and aborts' do
        dot_env_file = {}
        variables = ['APP']

        allow(namespace).to receive(:env_args).and_return(['APP=1'])
        allow(EnvLint).to receive(:verify_args).and_raise(Error.new('message'))
        expect(namespace).to receive(:abort)
        expect(formatter).to receive(:error).with('message')

        config.find_and_execute_task('env:lint_args')
      end
    end
  end
end
