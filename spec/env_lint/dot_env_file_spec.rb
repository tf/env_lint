require 'spec_helper'

module EnvLint
  describe DotEnvFile do
    describe '.parse' do
      it 'recognizes variables' do
        dot_env_file = DotEnvFile.parse(<<-END)
          APP=myapp
        END
        variable = dot_env_file.variables.first

        expect(variable.name).to eq('APP')
        expect(variable.value).to eq('myapp')
      end

      it 'recognizes double quoted values' do
        dot_env_file = DotEnvFile.parse(<<-END)
          APP="my app"
        END
        variable = dot_env_file.variables.first

        expect(variable.value).to eq('my app')
      end

      it 'recognizes single quoted values' do
        dot_env_file = DotEnvFile.parse(<<-END)
          APP='my app'
        END
        variable = dot_env_file.variables.first

        expect(variable.value).to eq('my app')
      end

      it 'handles empty assignments' do
        dot_env_file = DotEnvFile.parse(<<-END)
          APP=
        END
        variable = dot_env_file.variables.first

        expect(variable.value).to eq('')
      end

      it 'recognizes optional variables' do
        dot_env_file = DotEnvFile.parse(<<-END)
          # APP=myapp
          #OTHER=myapp
          APP=myapp
        END
        variable = dot_env_file.variables.first

        expect(dot_env_file.variables[0]).to be_optional
        expect(dot_env_file.variables[1]).to be_optional
        expect(dot_env_file.variables[2]).not_to be_optional
      end

      it 'recognites comments' do
        dot_env_file = DotEnvFile.parse(<<-END)
          # The name of the app
          APP=myapp
        END
        variable = dot_env_file.variables.first

        expect(variable.comment).to eq('The name of the app')
      end

      it 'recognites multi line comments' do
        dot_env_file = DotEnvFile.parse(<<-END)
          # The name of the app
          # and here the text goes on
          APP=myapp
        END
        variable = dot_env_file.variables.first

        expect(variable.comment).to eq("The name of the app\nand here the text goes on")
      end
    end
  end
end
