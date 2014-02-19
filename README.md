# Env Lint

<img src="https://travis-ci.org/tf/env_lint.png" data-bindattr-466="466" title="Build Status Images">

Check environment variables accoring to a `.env.example` file.

* Avoid spelling errors in variable names in your code or on the
  command line
* Ensure all relevant environment variables are described in the
  `.env.example` file.
* Ensure all required environment variables are configured before
  deploying a new version of an app
* Ease setting up a new development machine

# Status

Only tested with [recap](https://github.com/tomafro/recap) capistrano
tasks.

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

If special steps are needed 

### Capistrano Task

Require it in your `Capfile`:

    require 'env_lint/capistrano'

Now you can check your servers:

    $ cap env:lint
    => Complains if non optional variables are missing

You might want to lint the environment automatically before each
deploy.

    before 'deploy', 'env:lint'

Lint variable names before setting them:

    before 'env:set', 'env:lint_args'
    
    $ cap env:set APP_NAME=myapp
    => Complains if APP_NAME is defined

### Lint at Runtime

Access ENV through a `LintedEnv`:

    require 'env_lint'

    class MyApp
      LINTED_ENV = EnvLint::LintedEnv.from_file('.env.example')
      
      def self.env
        LINTED_ENV
      end
    end

Accessing env variables:

    # Ensures APP_NAME is defined in .env.example
    MyApp.env.fetch(:app_name, 'App name')

    # Ensures APP_NAME is non optional in .env.example
    MyApp.env.fetch(:app_name)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
