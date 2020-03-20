# Lifetime

Use this for your ActiveRecord models that are time bound with a start
and stop time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lifetime'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lifetime

## Usage

Include lifetime to you model:

``` ruby
#use the default lifetime fields: start_at, end_at
class License < ActiveRecord::Base
  include Lifetime
end

#use the custom lifetime fields
class License < ActiveRecord::Base
  include Lifetime
  lifetime_fields :start_date, :end_date
end

License.lifetime #returns lifetime of the license
License.first.lifetime_expired? #returns true if the license is expired
```

Check specs for more usage


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Cisco-AMP/lifetime.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
