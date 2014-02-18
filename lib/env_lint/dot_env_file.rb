module EnvLint
  class DotEnvFile
    attr_reader :name, :variables

    def initialize(name, variables)
      @name = name
      @variables = variables

      @variables_by_name = variables.each_with_object({}) do |variable, hash|
        hash[variable.name] = variable
      end
    end

    def find_variable(name)
      @variables_by_name[name]
    end

    def verify_no_missing(variable_names)
      find_missing(variable_names).tap do |missing_variables|
        raise(MissingVariables.new(self, missing_variables)) if missing_variables.any?
      end
    end

    def verify_no_unknown(variable_names)
      find_unknown(variable_names).tap do |unknown_names|
        raise(UnknownVariables.new(self, unknown_names)) if unknown_names.any?
      end
    end

    def self.from_file(file_name)
      new(file_name, DotEnvParser.new.parse(File.read(file_name)))
    end

    private

    def find_missing(variable_names)
      @variables.find_all do |variable|
        !variable.optional? && !variable_names.include?(variable.name)
      end
    end

    def find_unknown(variable_names)
      variable_names.find_all do |name|
        !@variables_by_name.key?(name)
      end
    end
  end
end
