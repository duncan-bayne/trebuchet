require 'bundler'
require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core/rake_task'
require 'rubygems'
require_relative 'lib/tasks/roodi.rb'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

desc 'Run static code quality checks.'
task :quality do
  pattern = File.join(File.dirname(__FILE__), "**", "*.rb")
  roodi(Dir.glob(pattern))
end

RSpec::Core::RakeTask.new(:spec)

task :default => [ :spec ]
