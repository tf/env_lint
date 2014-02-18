require 'spec_helper'

module EnvLint
  describe Environment do
    describe '.from_args' do
      it 'recognizes assignments' do
        args = ['APP=myname', 'NAME=test']
        environment = Environment.from_args(args)

        expect(environment).to have_variable('APP')
        expect(environment).to have_variable('NAME')
        expect(environment).not_to have_variable('OTHER')
      end

      it 'ignores other args' do
        args = ['env:set', 'APP=myname']
        environment = Environment.from_args(args)

        expect(environment.variable_names.size).to eq(1)
        expect(environment).to have_variable('APP')
      end
    end

    describe '.from_export_output' do
      it 'recognizes assignments' do
        output = <<-END
          declare -x APP="myapp"
          declare -x NAME="test"
        END
        environment = Environment.from_export_output(output)

        expect(environment).to have_variable('APP')
        expect(environment).to have_variable('NAME')
        expect(environment).not_to have_variable('OTHER')
      end
    end

    describe '.from_hash' do
      it 'recognizes assignments' do
        environment = Environment.from_hash('APP' => 'myapp',
                                                     'NAME' => 'test')

        expect(environment).to have_variable('APP')
        expect(environment).to have_variable('NAME')
        expect(environment).not_to have_variable('OTHER')
      end
    end
  end
end
