require 'formatador'

module EnvLint
  class Formatter
    def initialize(out = Formatador)
      @out = out
    end

    def missing_variables(dot_env_file, variables)
      error("Missing env variables:\n")

      variables.each do |variable|
        @out.display_line("  [yellow]#{variable.name}[/] - #{variable.comment}")
      end

      new_line
      info("Either set the variable or make it optional in the #{dot_env_file.name} file.")
    end

    def unknown_variables(dot_env_file, variable_names)
      error("Unknown env variables:\n")

      variable_names.each do |name|
        @out.display_line("  [yellow]#{name}[/]")
      end

      new_line
      info("Only variables descibred in #{dot_env_file.name} can be used.")
    end

    def error(message)
      @out.display_line("* [red]#{message}[/]")
    end

    def ok(message)
      @out.display_line("* [green]#{message}[/]")
    end

    private

    def info(message)
      @out.display_line("  #{message}")
    end

    def new_line
      @out.display_line('')
    end
  end
end
