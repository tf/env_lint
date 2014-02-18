module EnvLint
  class Formatter
    def initialize(out)
      @out = out
    end

    def missing_variables(dot_env_file, variables)
      if variables.any?
        @out.puts "Missing variables:"
      else
        @out.puts "The env looks complete."
      end

      variables.each do |variable|
        @out.puts("- #{variable.name}")
      end
    end

    def unknown_variables(dot_env_file, variable_names)
      if variable_names.any?
        @out.puts "Unknown variables:"
      end

      variable_names.each do |name|
        @out.puts("- #{name}")
      end
    end
  end
end
