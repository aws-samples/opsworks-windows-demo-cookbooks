require 'rspec/core/rake_task'

desc "Run ChefSpec tests"
RSpec::Core::RakeTask.new(:chefspec) do |t|
  t.pattern = "*/spec/*_spec.rb"
  t.verbose = true
end

task :test => [:chefspec]
task :default => :test
