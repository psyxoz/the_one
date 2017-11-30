#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You have to execute `gem install bundler` and `bundle install` to run this gem'
end

require 'dotenv/load'
require_relative('lib/the_one/the_one')

task :default do
  TheOne.perform
  puts 'All set!'
end
