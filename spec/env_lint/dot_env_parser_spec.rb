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

      it 'ignores blank linkes' do
        variables = DotEnvParser.new.parse(<<-END)
          APP1=myapp

          APP2=myapp
        END

        expect(variables.count).to eq(2)
        expect(variables.first.name).to eq('APP1')
        expect(variables.last.name).to eq('APP2')
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

      it 'recognizes comments' do
        variables = DotEnvParser.new.parse(<<-END)
          # The name of the app
          APP=myapp
        END

        expect(variables.first.comment).to eq('The name of the app')
      end

      it 'recognizes multi line comments' do
        variables = DotEnvParser.new.parse(<<-END)
          # The name of the app
          # and here the text goes on
          APP=myapp
        END

        expect(variables.first.comment).to eq("The name of the app\nand here the text goes on")
      end

      it 'starts new comment at blank line' do
        variables = DotEnvParser.new.parse(<<-END)
          # This is some header which is not related
          # to the following variable

          # This is the comment
          APP=myapp
        END

        expect(variables.first.comment).to eq('This is the comment')
      end

      it 'raises exception for unrecognized line' do
        text = <<-END
          what is this?
        END

        expect {
          DotEnvParser.new.parse(text)
        }.to raise_error(UnrecognizedDotEnvLine)
      end
    end
  end
end
