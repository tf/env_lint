require 'spec_helper'

module EnvLint
  describe DotEnvParser do
    describe '#parse' do
      it 'recognizes variables' do
        variables = DotEnvParser.new.parse(<<-END)
          APP=myapp
        END

        expect(variables.first.name).to eq('APP')
        expect(variables.first.value).to eq('myapp')
      end

      it 'recognizes double quoted values' do
        variables = DotEnvParser.new.parse(<<-END)
          APP="my app"
        END

        expect(variables.first.value).to eq('my app')
      end

      it 'recognizes single quoted values' do
        variables = DotEnvParser.new.parse(<<-END)
          APP='my app'
        END

        expect(variables.first.value).to eq('my app')
      end

      it 'handles empty assignments' do
        variables = DotEnvParser.new.parse(<<-END)
          APP=
        END

        expect(variables.first.value).to eq('')
      end

      it 'recognizes optional variables' do
        variables = DotEnvParser.new.parse(<<-END)
          # APP=myapp
          #OTHER=myapp
          APP=myapp
        END

        expect(variables[0]).to be_optional
        expect(variables[1]).to be_optional
        expect(variables[2]).not_to be_optional
      end

      it 'recognites comments' do
        variables = DotEnvParser.new.parse(<<-END)
          # The name of the app
          APP=myapp
        END

        expect(variables.first.comment).to eq('The name of the app')
      end

      it 'recognites multi line comments' do
        variables = DotEnvParser.new.parse(<<-END)
          # The name of the app
          # and here the text goes on
          APP=myapp
        END

        expect(variables.first.comment).to eq("The name of the app\nand here the text goes on")
      end
    end
  end
end
