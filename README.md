# Env Lint

[![Gem Version](https://badge.fury.io/rb/env_lint.png)](http://badge.fury.io/rb/env_lint)
[![Build Status](https://travis-ci.org/tf/env_lint.svg?branch=master)](https://travis-ci.org/tf/env_lint)

Check configuration of [12 factor apps](http://12factor.net/config)
according to to a `.env.example` file.

* Avoid spelling errors in variable names in your code or on the
  command line
* Ensure all relevant environment variables are described in the
  `.env.example` file.
* Ensure all required environment variables are configured before
  deploying a new version of an app
* Ease setting up a new development machine
* Plays well with [dotenv](https://github.com/bkeepers/dotenv)

If you'd rather read some prose, there's also a
[blog post](http://stderr.timfischbach.de/2014/02/20/environment-liniting-for-12-factor-apps.html)
explaining why we got started with env_lint.

## Status

Used in production. Following semantic versioning. Capistrano tasks
only tested with [recap](https://github.com/tomafro/recap) capistrano
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

If special steps are needed to setup your env, you can define a
`env:load` task. For example to integrate with
[Dotenv](https://github.com/bkeepers/dotenv):

    require 'env_lint/tasks'
    require 'dotenv'

    namespace :env do
      task :load do
        Dotenv.load
      end
    end

### Capistrano Task

Require it in your `Capfile`:

    require 'env_lint/capistrano'

Now you can check your servers:

    $ cap env:lint
    => Complains if non optional variables are missing

You might want to lint the environment automatically before each
deploy:

    before 'deploy', 'env:lint'

By default, env_lint tries to run `export` as your recap application
user. The probe command can be configured:

    set(:env_probe_command, "su - deploy -c 'export'")

Lint variable names before setting them:

    before 'env:set', 'env:lint_args'

    $ cap env:set APP_NAME=myapp
    => Complains if APP_NAME is not defined

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

## Alternatives

* [ENV_BANG](https://github.com/jcamenisch/ENV_BANG) - Offers a ruby
  DSL. Comes with type conversion features. Does not include tasks to
  check environment variables without running the app.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
