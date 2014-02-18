require 'env_lint/dot_env_file'
require 'env_lint/dot_env_parser'
require 'env_lint/formatter'
require 'env_lint/environment'
require 'env_lint/errors'
require 'env_lint/linted_env'
require 'env_lint/variable'
require 'env_lint/version'

module EnvLint
  def self.verify_hash(env_definition_file, env, out = $stdout)
    dot_env_file = DotEnvFile.from_file(env_definition_file)
    missing_variables = Verification.new(dot_env_file)
      .find_missing(Environment.from_hash(env))

    formatter(out).missing_variables(dot_env_file, missing_variables)
  end

  def self.verify_export_output(env_definition_file, export_output, out = $stdout)
    dot_env_file = DotEnvFile.from_file(env_definition_file)
    missing_variables = Verification.new(dot_env_file)
      .find_missing(Environment.from_export_output(export_output))

    formatter(out).missing_variables(dot_env_file, missing_variables)
  end

  def self.verify_args(env_definition_file, args, out = $stdout)
    dot_env_file = DotEnvFile.from_file(env_definition_file)
    unknown_variables = Verification.new(dot_env_file)
      .find_unknown(Environment.from_args(args))

    formatter(out).unknown_variables(dot_env_file, unknown_variables)
  end

  private

  def self.formatter(out)
    Formatter.new(out)
  end
end
