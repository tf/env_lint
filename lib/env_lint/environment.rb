module EnvLint
  class Environment
    attr_reader :variable_names

    def initialize(variable_names)
      @variable_names = variable_names
    end

    def has_variable?(name)
      @variable_names.include?(name)
    end

    def self.from_args(args)
      new(args.map { |arg| arg.split('=').first })
    end

    def self.from_export_output(text)
      from_args(text.split(/[\n\r]/).map { |line| line.gsub('declare -x', '').strip })
    end

    def self.from_hash(hash)
      new(hash.keys)
    end
  end
end
