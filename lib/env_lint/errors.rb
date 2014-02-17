module EnvLint
  class VariableError < StandardError
    attr_reader :variable_name

    def initialize(variable_name, message)
      super(message)
      @variable_name = variable_name
    end
  end

  class UnknownVariable < VariableError
    def initialize(variable_name)
      super(variable_name, "Unknown variable #{variable_name}.")
    end
  end

  class DefaultValueRequiredForOptionalVariable < VariableError
    def initialize(variable_name)
      super(variable_name, "Non optional variable #{variable_name} used without default value.")
    end
  end

  class MissingVariable < VariableError
    def initialize(variable_name)
      super(variable_name, "Missing variable #{variable_name}. Check your .env file")
    end
  end
end
