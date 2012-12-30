source ~/.bashrc | /dev/null
cd . | /dev/null
bundle install
rake db:schema:load
SPEC_OPTS="--format html" rake rspec
CUCUMBER_FORMAT=html rake cucumber
