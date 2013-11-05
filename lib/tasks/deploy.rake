require 'sshkit/dsl'
require 'highline/import'

namespace :deploy do
  desc 'Deploy to production'
  task :production do |t, args|
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

  desc 'Deploy to staging'
  task :staging do |t, args|
    user = ask('Enter username:')
    on %W{#{user}@alexandria.ad.sofse.org} do
      within "/staging" do
        with rails_env: :staging do
          execute :git, 'pull'
          execute :bundle, '--without development:test','install'
          rake 'db:migrate assets:precompile'
          execute :touch, 'tmp/restart.txt'
        end
      end
    end
  end
end