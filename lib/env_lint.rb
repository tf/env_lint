require 'env_lint/dot_env_file'
require 'env_lint/dot_env_parser'
require 'env_lint/formatter'
require 'env_lint/env_key_parser'
require 'env_lint/errors'
require 'env_lint/linted_env'
require 'env_lint/variable'
require 'env_lint/version'

module EnvLint
  def self.verify_hash(env_definition_file, env)
    DotEnvFile.from_file(env_definition_file).verify_no_missing(env.keys)
  end

  def self.verify_export_output(env_definition_file, export_output)
    DotEnvFile.from_file(env_definition_file)
      .verify_no_missing(EnvKeyParser.new.parse_export_output(export_output))
  end

  def self.verify_args(env_definition_file, args)
    DotEnvFile.from_file(env_definition_file)
      .verify_no_unknown(EnvKeyParser.new.parse_args(args))
  end
end
