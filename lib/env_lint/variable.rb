module EnvLint
  class Variable < Struct.new(:name, :value, :optional, :comment)
    alias_method :optional?, :optional
  end
end
