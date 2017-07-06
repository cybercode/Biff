require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/version_task'

Rake::VersionTask.new

RSpec::Core::RakeTask.new(:spec)

task default: :spec
task test: :spec
