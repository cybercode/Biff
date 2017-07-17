#!/usr/bin/env ruby
# <bitbar.title>IMAP Biff</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Rick Frankel</bitbar.author>
# <bitbar.author.github>cybercode</bitbar.author.github>
# <bitbar.desc>Get Inbox counts and unsheed headers for multiple mailboxes. Expects ~/.biff.yaml config file</bitbar.desc>
# <bitbar.dependencies>ruby, biff rubygem (gem install biff)</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/cybercode/Biff</bitbar.abouturl>

require 'biff/cli'

def report(cli)
  statii = cli.status
  all = statii.sum(&:all)
  unseen = statii.sum(&:unseen)
  icon = ':envelope:'
  attrs = ''
  if unseen.positive?
    icon = ':mailbox:'
    attrs = '|color=green'
  end
  puts "#{icon}#{unseen}/#{all}#{attrs}"
  puts '---'
  statii.each do |s|
    cmd = cli.servers[s.name].cmd
    attrs = '|'
    attrs += 'color=green' if s.unseen.positive?
    attrs += " bash=#{cmd} terminal=false" if cmd
    puts "#{s.name} #{s.unseen}/#{s.all}#{attrs}"
    if s.unseen.positive?
      cli.servers[s.name].unseen_headers.map do |h|
        puts "﻿#{h}|font='Menlo Regular' size=12"
      end
    end
    puts '---'
  end
  puts 'Check Now…|refresh=true'

  cli.servers.values.each(&:run)
end

cli = Biff::CLI.new
report(cli)
