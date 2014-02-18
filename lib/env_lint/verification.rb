module EnvLint
  class Verification
    def initialize(dot_env_file)
      @dot_env_file = dot_env_file
    end

    def find_missing(environment)
      @dot_env_file.variables.find_all do |variable|
        !variable.optional? && !environment.has_variable?(variable.name)
      end
    end

    def find_unknown(environment)
      environment.variable_names.find_all do |name|
        !@dot_env_file.find_variable(name)
      end
    end
  end
end
