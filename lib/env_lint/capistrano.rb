module EnvLint
  namespace :env do
    _cset(:env_definition_file) { '.env.example' }

    _cset(:env_probe_command) { "su - #{application_user} -c 'export'" }

    desc ''
    task :lint do
      begin
        EnvLint.verify_export_output(env_definition_file, capture(env_probe_command))
      rescue EnvLint::Error => e
        puts e.message
      end
    end

    desc ''
    task :lint_args do
      begin
        EnvLint.verify_args(env_definition_file, ARGV[1..-1])
      rescue EnvLint::Error => e
        puts e.message
      end
    end
  end
end
