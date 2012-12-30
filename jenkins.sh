source ~/.bashrc 
cd .
rvm gemset use alexandria
rvm gemset list
bundle install
rake db:schema:load
SPEC_OPTS="--format html" rake rspec
CUCUMBER_FORMAT=html rake cucumber
