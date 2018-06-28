# OnePassCli

A Commandline utility to make the one password cli a bit more user friendly for an interactive user rather than an automated system

## Installation

You will require the 1password commandline utility installed and should have already signed in at least once to the required 1password server (subdomain)

Downloads are available here:
https://app-updates.agilebits.com/product_history/CLI

Sign into 1password by running the following:

`op signin <subdomain>.1password.com <email_address> <secret_key>`

It will ask for your password as well to complete setup

From within this directory run `bundle exec rake install`

## Usage

Once the `op` command has been installed and is available on the PATH, you can run this cli:

`one_pass_cli <subdomain> <search term>`

It will ask for your password each time.

Passing the flag `--show` will show the passwords in plaintext in the terminal. Without this flag passwords will be copied directly to the clipboard

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/one_pass_cli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
