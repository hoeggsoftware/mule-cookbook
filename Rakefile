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
    RSpec::Core::RakeTask.new(:spec)
end

namespace :integration do
    desc 'Run kitchen integration tests'
    task :vagrant do
        Kitchen::Config.new.instances.each do |instance|
	    instance.test(:always)
        end
    end

    task :codeship do
       Kitchen.logger = Kitchen.default_file_logger 
       @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
        config = Kitchen::Config.new(loader: @loader)
        config.instances.each do |instance|
            instance.test(:always)
        end
    end
end

task codeship: ['unit:spec', 'integration:codeship']

task default: ['unit:spec', 'style:chef', 'integration:vagrant']
