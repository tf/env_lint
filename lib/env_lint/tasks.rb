namespace :env do
  desc 'Ensure every non optional ENV variable is defined.'
  task :lint => :load do
    begin
      EnvLint.verify_hash(env_definition_file, ENV)
      EnvLint.formatter.ok('env looks ok')
    rescue EnvLint::MissingVariables => e
      EnvLint.formatter.missing_variables(e.dot_env_file, e.missing_variables)
      abort
    rescue EnvLint::Error => e
      EnvLint.formatter.error(e.message)
    end
  end

  task :load do
  end

  def env_definition_file
    ENV['DEFINITION'] || '.env.example'
  end
end
