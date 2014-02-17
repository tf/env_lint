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

    def self.from_file(file_name)
      new(file_name, DotEnvParser.new.parse(File.read(file_name)))
    end
  end
end
