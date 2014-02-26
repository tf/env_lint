require 'env_lint'
require 'capistrano'

module EnvLint
  module Capistrano
    def self.load_into(config, formatter)
      config.load do
        set(:env_definition_file) { '.env.example' }
        set(:env_probe_command) { "su - #{application_user} -c 'export'" }

        namespace :env do
          desc 'Check that every non optional ENV variable is defined.'
          task :lint do
            begin
              EnvLint.verify_export_output(env_definition_file, capture("#{sudo} #{env_probe_command}"))
              formatter.ok('env looks ok')
            rescue EnvLint::MissingVariables => e
              formatter.missing_variables(e.dot_env_file, e.missing_variables)
              abort
            rescue EnvLint::Error => e
              formatter.error(e.message)
              abort
            end
          end

          desc 'Lint args passed to command.'
          task :lint_args do
            begin
              EnvLint.verify_args(env_definition_file, env_args)
            rescue EnvLint::UnknownVariables => e
              formatter.unknown_variables(e.dot_env_file, e.unknown_variables)
              abort
            rescue EnvLint::Error => e
              formatter.error(e.message)
              abort
            end
          end

          def env_args
            ARGV[1..-1]
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  EnvLint::Capistrano.load_into(Capistrano::Configuration.instance(:must_exist),
                                EnvLint::Formatter.new)
end
