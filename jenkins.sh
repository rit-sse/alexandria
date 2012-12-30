source ~/.bashrc
cd .
bundle install
rake db:migrate
rake db:schema:load
rake spec
CUCUMBER_FORMAT=html rake cucumber
