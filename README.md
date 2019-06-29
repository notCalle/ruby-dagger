[![Gem Version](https://badge.fury.io/rb/ruby-dagger.svg)](https://badge.fury.io/rb/ruby-dagger)
[![Maintainability](https://api.codeclimate.com/v1/badges/4038215eb129292a826d/maintainability)](https://codeclimate.com/github/notCalle/ruby-dagger/maintainability)
[![codecov](https://codecov.io/gh/notCalle/ruby-dagger/branch/master/graph/badge.svg)](https://codecov.io/gh/notCalle/ruby-dagger)
[![Build Status](https://dev.azure.com/notCalle/GitHub%20CI/_apis/build/status/notCalle.ruby-tangle)](https://dev.azure.com/notCalle/GitHub%20CI/_build/latest?definitionId=2)

# Dagger

`Dagger` can manage a
[directed acyclic graph](https://github.com/notcalle/tangle) of
[key trees](https://github.com/notcalle/keytree), inspired by the ideas behind [PalletJack](https://github.com/saab-simc-admin/palletjack).

The DAG is stored in a regular posix file system hierarchy, where
_directories_ are vertices with a forest of key trees from the contained
_files_. Edges are formed from the directory structure, and _symlinks_.

Edge direction (default top->down & target->source) is selectable,
but key tree inheritence is always top->down & target->source.

```
spec/fixture/graph
├── vertex1
│   ├── a.yaml                  # a.b = 2
│   └── c.yaml                  # c = 3
└── vertex2
    ├── b.yaml                  # b = 2
    └── parent -> ../vertex1    # a.b = 2, c = 3
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-dagger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-dagger

## Usage

    $ bin/console
```ruby
g=Dagger.load('spec/fixture/graph')
=> #<Dagger::Graph: 3 vertices, 3 edges>
g['/vertex1']['a.b']
=> 2
g['/vertex2']['a.b']
=> 2
g['/vertex2'].local['a.b']
=> nil
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/notCalle/ruby_dagger. Pull requests should be rebased to HEAD of `master` before submitting, and all commits must be signed with valid GPG key. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RubyDagger project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/notCalle/ruby_dagger/blob/master/CODE_OF_CONDUCT.md).
