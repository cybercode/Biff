# Biff

Ruby Imap IDLE based biff utility.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'biff'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install biff

## Usage

The gem provides two command-line scripts, `biffer` (to avoid conflict w/ system `biff` command) and `biff.5m.rb`. `biffer` uses `net/imap#listen` to wait for INBOX changes and print "{server name}:{unseen}/{all}".

`biff.1m.rb` is a [BitBar](https://getbitbar.com) script, which will run every minute to update the menubar entry.

Both scripts use (by default) the configuration in ~/.biff.yaml, which should be in the following format, multiple top-level keys (servers) are allowd. Note that one of either `password` or `passcmd` is required.

```yaml
Name:
  host: required.host.address
  user: required_user_name
  password: optional_password
  passcmd: shell_command_if_password_not_specified
  run: optional_command_to_run_after_inbox_changes
  cmd: optional_email_command_for_bitbar_menu_hot_link
```

Note that if you are using, e.g., `rbenv` to manage your ruby versions and gems, you can't use `biff.5m.rb` directly in your plugin directory. A shell script like the following will work:

``` zsh
#!/bin/zsh --login

export RBENV_ROOT=/usr/local/var/rbenv
export RBENV_GEMSETS=global
export RBENV_VERSION=2.4.1

exec $RBENV_ROOT/shims/biff.5m.rb
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cybercode/Biff.
