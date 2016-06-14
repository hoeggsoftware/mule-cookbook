require 'rspec/core/rake_task'
require 'foodcritic'
require 'kitchen'

namespace :style do
    desc 'Run Chef style checks'
    FoodCritic::Rake::LintTask.new(:chef) do |t|
        t.options = {
            fail_tags: ['any']
        }
    end
end

namespace :unit do
    desc 'Runs specs with chefspec.'
    RSpec::Core::RakeTask.new(:rspec)
end
namespace :integration do
    desc 'Run kitchen integration tests'
    Kitchen::RakeTasks.new
end

task codeship: ['unit']

task default: ['unit', 'style', 'integration:kitchen:all']
