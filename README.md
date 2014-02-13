# Env Lint

Check environment variables accoring to a `.env.example` file.

## Status

Work in progress. This README only outlines the desired functionality so far.

## Installation

Add this line to your application's Gemfile:

    gem 'env_lint'

## Usage

Define a `.env.example` file:

    # Explain each variable in comments like this one
    APP_NAME=my_app
    
    # Comments are also recognized if they span multiple
    # lines
    FEATURE=true
    
    # Optional variables
    # OPTIONAL_VAR="set me if you like"

### Rake Task

Require it in your `Rakefile`:

    require 'env_lint/tasks'

Now you can check your environment:

    $ rake env:lint
    => Complains if non optional variables are missing
    
Setup your personal `.env` file in an interactive session:

    % rake env:setup
    => Prompts for each variable with explanantion

### Capistrano Task

Require it in your `Capfile`:

    require 'env_lint/capistrano'

Now you can check your servers:

    $ cap env:lint
    => Complains if non optional variables are missing

### Lint at Runtime

Access ENV through a `LintedEnv`:

    require 'env_lint'

    class MyApp
      LINTED_ENV = EnvLint::LintedEnv.new
      
      def self.env
        LINTED_ENV
      end
    end

Accessing env variables:

    # Ensures APP_NAME is defined in .env.example
    MyApp.env.fetch(:app_name, 'App name')

    # Ensures APP_NAME is non optional in .env.example
    MyApp.env.fetch(:app_name)

Using different example file:

    LINTED_ENV = EnvLint::LintedEnv.new('.env.ci')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
