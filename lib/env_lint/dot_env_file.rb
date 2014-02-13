module EnvLint
  class DotEnvFile
    class Variable < Struct.new(:name, :value, :optional, :comment)
      alias_method :optional?, :optional
    end

    attr_reader :variables

    def initialize(variables)
      @variables = variables
    end

    def self.parse(text)
      comment_lines = []

      variables = text.lines.each_with_object([]) do |line, result|
        if match = line.strip.match(ASSIGNMENT)
          optional, name, value = match.captures
          value ||= ''
          value = value.strip.sub(/\A(['"])(.*)\1\z/, '\2')

          result << Variable.new(name, value, !!optional, comment_lines * "\n")
          comment_lines = []
        elsif match = line.strip.match(COMMENT)
          comment_lines << match.captures.first
        end
      end

      DotEnvFile.new(variables)
    end

    COMMENT = /\A#\s*(.*)\z/

    ASSIGNMENT = /
      \A
      (\#\s*)?          # optional variable marker
      ([\w\.]+)         # key
      =                 # separator
      (                 # optional value begin
        [^#\n]+         #   unquoted value
      )?                # value end
      \z
     /x
  end
end
