require 'spec_helper'

module EnvLint
  describe EnvKeyParser do
    describe '.parse_args' do
      it 'recognizes assignments' do
        parser = EnvKeyParser.new

        keys = parser.parse_args(['APP=myname', 'NAME=test'])

        expect(keys).to eq(['APP', 'NAME'])
      end

      it 'ignores other args' do
        parser = EnvKeyParser.new

        keys = parser.parse_args(['env:set', 'APP=myname'])

        expect(keys).to eq(['APP'])
      end
    end

    describe '.parse_export_output' do
      it 'recognizes assignments' do
        parser = EnvKeyParser.new

        keys = parser.parse_export_output(<<-END)
          declare -x APP="myapp"
          declare -x NAME="test"
        END

        expect(keys).to eq(['APP', 'NAME'])
      end
    end
  end
end
