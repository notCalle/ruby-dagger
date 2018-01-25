require 'bundler/setup'
require 'bundler/gem_tasks'

desc 'Run RuboCop'
require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options << '--display-cop-names'
end

desc 'Run RSpec'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: %i[rubocop spec]
