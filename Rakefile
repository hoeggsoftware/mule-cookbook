require 'rspec/core/rake_task'
require 'foodcritic'
require 'kitchen'
require_relative 'lib/do_connection'

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

  task :digital_ocean do
    Kitchen.logger = Kitchen.default_file_logger 
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end

  task :digital_ocean_with_auto_key do
    do_connection = Helpers::DOConnection.new
    do_connection.register_do_key!
    do_connection.setup_keyfile!
    Kitchen.logger = Kitchen.default_file_logger 
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
    do_connection.unregister_do_key!
    do_connection.cleanup_keyfile!
  end
end

task codeship: ['unit:spec', 'integration:digital_ocean']

task default: ['unit:spec', 'style:chef', 'integration:vagrant']
