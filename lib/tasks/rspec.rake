begin
  require 'rspec'

  Rake.application.instance_variable_get("@tasks").delete("spec")

  require 'rspec/core/rake_task'
  desc "Run all specs"
  RSpec::Core::RakeTask.new(:spec => 'db:test:prepare') do |t|
    t.rspec_opts = ['--format RspecJunitFormatter', '--out rspec.xml']
  end
rescue LoadError
  desc 'rspec rake task not available (rspec not installed)'
  task :spec do
    abort 'Rspec rake task is not available. Be sure to install rspec as a gem or plugin'
  end
end
