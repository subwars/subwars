#!/usr/bin/env rake
# Silence MagLev messages
def Process.fork; nil; end

require 'rake/testtask'
Rake::TestTask.new do |task|
  task.libs << %w(test .)
  task.pattern = 'test/**/test_*.rb'
end

task :default => :test

task :app do
  require './app'
end

Dir[File.dirname(__FILE__) + "/lib/tasks/*.rb"].sort.each do |path|
  require path
end
