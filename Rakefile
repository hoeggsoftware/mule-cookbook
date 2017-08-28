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

  # Task expects to be called with a config_file_path pointing to a .ssh/config
  # Otherwise, it assumes it is located at /home/jenkins/.ssh/config
  task :cloud, [:config_file_path] do |_, args|
    do_connection = Helpers::DOConnection.new(
      config_file_path: args[:config_file_path] || "/home/jenkins/.ssh/config"
    )
    do_connection.register_do_key!
    Kitchen.logger = Kitchen.default_file_logger 
    loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
    config = Kitchen::Config.new(loader: loader)
    config.instances.each do |instance|
      Process.fork { instance.test(:always) }
    end
    results = Process.waitall
    do_connection.unregister_do_key!
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
