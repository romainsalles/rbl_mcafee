# RblMcafee

Solution to test if an IP address is listed in the McAfee RBL.

McAfee uses the Spamhaus Project (https://www.spamhaus.org/).

## Installation

Add this line to your application's Gemfile:

    gem 'rbl_mcafee'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbl_mcafee

## Usage

To verify if an IP address is listed in one of the Spamhaus IP zones:

```ruby
zone = RblMcafee::Zone.new('127.0.0.1')
zone.pbl?
zone.sbl?
zone.xbl?
```

Expected returned values are the following:

* `true` when the IP address **is listed** in the zone
* `false` when the IP address **isn't listed** in the zone

When a **timeout** occurs, a `RblMcafee::Timeout` exception is raised.

## Contributing

1. Fork it ( https://github.com/romainsalles/rbl_mcafee/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
