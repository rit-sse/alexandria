source ~/.bashrc 
cd .
pwd
ruby -v
rvm gemset list
bundle install
rake db:schema:load
SPEC_OPTS="--format html" rake rspec
CUCUMBER_FORMAT=html rake cucumber
