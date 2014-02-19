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
        args.empty? ? raise(MissingVariable.new(name)) : args.first
      end

      @env.fetch(name, &block)
    end

    def self.from_file(file_name)
      new(ENV, DotEnvFile.from_file(file_name))
    end
  end
end
