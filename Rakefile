require "bundler/gem_tasks"
# require 'rspec/core/rake_task'

require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
end

task default: :test
