require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << %w(lib test)
  t.ruby_opts << '-rubygems -rtest_helper'
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = false
end
