module EnvLint
  class LintedEnv
    def initialize(env, dot_env_file)
      @env = env
      @dot_env_file = dot_env_file
    end

    def fetch(name, *args, &block)
      name = name.to_s.upcase if name.is_a?(Symbol)
      variable = @dot_env_file.find_variable(name)

      raise(UnknownVariable.new(name)) unless variable

      if variable.optional? && args.empty? && !block_given?
        raise(DefaultValueRequiredForOptionalVariable.new(name))
      end

      block ||= lambda do |i|
        args.any? ? args.first : raise(MissingVariable.new(name))
      end

      @env.fetch(name, &block)
    end
  end
end
