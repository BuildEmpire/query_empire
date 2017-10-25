# QueryEmpire

Query Empire is a small gem that provides an easy way to store advanced AR
queries. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'query_empire'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install query_empire

## Usage

QueryEmpire provides *.filter* method to AR models in Rails application:

```ruby
params = {
  filters: {
    name: { eq: 'Jon' }
  }
}
Person.filter(params)
``` 

Self-explanatory list of parameters that can be provided to *.filter* method: 
* table
* filters
* order_by
* order_direction
* columns
* headings
* limit
* page
* offset
* joins
* includes
* scopes

Detailed examples of usage are in tests suite.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BuildEmpire/query_empire. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QueryEmpire project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/query_empire/blob/master/CODE_OF_CONDUCT.md).
