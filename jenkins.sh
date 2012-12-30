source ~/.bashrc
cd .
bundle install
rake db:migrate
rake spec
bundle exec cucumber -f junit --out ./cucumber.xml
