module EnvLint
  namespace :env do
    task :lint => :load do
      begin
        EnvLint.verify_hash(env_definition_file, ENV)
      rescue EnvLint::Error => e
        puts e.message
      end
    end

    task :load do
    end

    def env_definition_file
      ENV['DEFINITION'] || '.env.example'
    end
  end
end
