#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :default => [:spec]

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['-b -fd']
end
