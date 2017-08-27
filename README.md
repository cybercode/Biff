# Biff

Ruby Imap IDLE based biff utility.

## Installation

    $ gem install biff

or the usual `bundler` incantations if you want to use the library in another app.

## Usage

The gem provides two command-line scripts, `biffer` (to avoid conflict w/ system `biff` command) and `biff.5m.rb`. `biffer` uses `net/imap#listen` to wait for INBOX changes and prints "{server name}:{unseen}/{all}". It will exit immediately with an error if the IMAP server does not have the IDLE capability. 

`biff.5m.rb` is a [BitBar](https://getbitbar.com) script, which will run every 5 minutes to update the menubar entry.

Both scripts use (by default) the configuration in ~/.biff.yaml, which should be in the following format, multiple top-level keys (servers) are allowed. Note that one of `password`, `passcmd`, `token` or `tokencmd` is required.

`token` and `tokencmd` are used for gmail oauth2 authentication, and will generate a runtime error if the [gmail_xoauth](https://github.com/nfo/gmail_xoauth) gem is not installed. See the [gmail_xoauth](https://github.com/nfo/gmail_xoauth) homepage for info on how to generate an oauth2 token.

```yaml
Name:
  host: required.host.user
  addressmak: required_user_name
  password: optional_password
  passcmd: shell_command_if_password_not_specified
  token: gmail_app_oauth2_token
  tokencmd: shell_command_for_gmail_token
  run: optional_command_to_run_after_inbox_changes
  cmd: optional_email_command_for_bitbar_menu_hot_link
  debug: optional_set_net_imap_debug
```

Typically, `security find-internet-password -a {email-login} -w` is a good choice for `passcmd`. If your IMAP server is on Microsofit Office365, try `security find-internet-password -s 'mail.office365.com' -w` instead.

Note that if you are using, e.g., `rbenv` to manage your ruby versions and gems, you can't use `biff.5m.rb` directly in your plugin directory. A shell script like the following will work:

``` zsh
#!/bin/zsh --login

export RBENV_ROOT=/usr/local/var/rbenv
export RBENV_GEMSETS=global
export RBENV_VERSION=2.4.1

exec $RBENV_ROOT/shims/biff.5m.rb
```
## Development

After checking out the repo, run `bundle install` to install dependencies. You can run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cybercode/Biff.
