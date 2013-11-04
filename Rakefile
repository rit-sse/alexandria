# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'sunspot/solr/tasks'
require 'sshkit/dsl'
require 'highline/import'

Alexandria::Application.load_tasks

task :deploy do |t, args|
  user = ask('Enter username:')
  on %W{#{user}@alexandria.ad.sofse.org} do
    within "/alexandria" do
      with rails_env: :production do
        execute :git, 'pull'
        execute :bundle, '--without development:test','install'
        rake 'db:migrate assets:precompile'
        execute :touch, 'tmp/restart.txt'
      end
    end
  end
end