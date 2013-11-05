require 'sshkit/dsl'
require 'highline/import'

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