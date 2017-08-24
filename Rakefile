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

  task :cloud do
    do_connection = Helpers::DOConnection.new
    do_connection.register_do_key!
    do_connection.setup_keyfile!
    Kitchen.logger = Kitchen.default_file_logger 
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      Process.fork do
        instance.test(:always)
      end
    end
    results = Process.waitall
    do_connection.unregister_do_key!
    do_connection.cleanup_keyfile!
    statuses = results.flatten.select { |p| p.class == Process::Status }
    if statuses.all? { |process| process.exitstatus == 0 }
      exit 0
    else
      exit 1
    end
  end
end

task cloud: ['unit:spec', 'integration:cloud']

task default: ['unit:spec', 'style:chef', 'integration:vagrant']
