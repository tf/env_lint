module EnvLint
  class Verification
    def initialize(dot_env_file)
      @dot_env_file = dot_env_file
    end

    def complete?(environment)
      @dot_env_file.variables.each do |variable|
        if !variable.optional? && !environment.has_variable?(variable.name)
          raise(MissingVariable.new(variable.name))
        end
      end
    end

    def all_known?(environment)
      environment.variable_names.each do |name|
        unless @dot_env_file.find_variable(name)
          raise(UnknownVariable.new(name))
        end
      end
    end
  end
end
