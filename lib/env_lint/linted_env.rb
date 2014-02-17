module EnvLint
  class LintedEnv
    def initialize(env, variables)
      @env = env
      @variables = variables
    end

    def fetch(name, *args, &block)
      name = name.to_s.upcase if name.is_a?(Symbol)
      variable = find_variable(name)

      raise(UnknownVariable.new(name)) unless variable

      if variable.optional? && args.empty? && !block_given?
        raise(DefaultValueRequiredForOptionalVariable.new(name))
      end

      block ||= lambda do |i|
        args.any? ? args.first : raise(MissingVariable.new(name))
      end

      @env.fetch(name, &block)
    end

    private

    def find_variable(name)
      @variables.find do |variable|
        variable.name == name
      end
    end
  end
end
