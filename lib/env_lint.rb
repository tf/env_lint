require 'env_lint/dot_env_file'
require 'env_lint/dot_env_parser'
require 'env_lint/environment'
require 'env_lint/errors'
require 'env_lint/linted_env'
require 'env_lint/variable'
require 'env_lint/verification'
require 'env_lint/version'

module EnvLint
  def self.verify_hash(env_definition_file, env)
    verification(env_definition_file).complete?(Environment.from_hash(env))
  end

  def self.verify_args(env_definition_file, args)
    verification(env_definition_file).all_known?(Environment.from_args(args))
  end

  def self.verify_export_output(env_definition_file, output)
    verification(env_definition_file).complete?(Environment.from_export_output(output))
  end

  private

  def self.verification(env_definition_file)
    Verification.new(DotEnvFile.from_file(env_definition_file))
  end
end
