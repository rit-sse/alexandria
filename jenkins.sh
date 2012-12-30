source ~/.bashrc 
cd .
[ -d jenkins ] && rm -rf jenkins
pwd
mkdir jenkins
bundle install > jenkins/bundler.txt
rake db:schema:load > jenkins/schema_load.txt
SPEC_OPTS="--format html" rake rspec > jenkins/rspec.html
CUCUMBER_FORMAT=html rake cucumber > jenkins/cucumber.html
