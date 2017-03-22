# Rack::RevisionRoute

Rack::RevisionRoute is a Rack middleware that adds route to get source code revision.
Source code revision is guessed by `REVISION` file or `git log -1`.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-revision_route', git: "https://github.com/labocho/rack-revision_route.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-revision_route

## Usage

Use `Rack::RevisionRoute` as Rack middleware with application root directory and path to get revision.

For Rack application, in `config.ru`

    require "rack/revision_route"
    use Rack::RevisionRoute, __dir__, "/revision"

For Rails application, create `config/initializers/rack-revision_route.rb` like

    require "rack/revision_route"
    Rails.application.middleware.use Rack::RevisionRoute, Rails.root, "/revision"

For Sinatra application

    require "rack/revision_route"
    use Rack::RevisionRoute, __dir__, "/revision"

    # or
    require "rack/revision_route"
    class YourApp < Sinatra::Base
      use Rack::RevisionRoute, APP_ROOT, "/revision"
    end


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/labocho/rack-revision_route.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

