module EnvLint
  class EnvKeyParser
    def parse_args(args)
      args.map { |arg| arg.split('=').first if arg.include?('=') }.compact
    end

    def parse_export_output(text)
      parse_args(text.split(/[\n\r]/).map { |line| line.gsub('declare -x', '').strip })
    end
  end
end
