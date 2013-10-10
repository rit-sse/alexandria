Alexandria
==========
[![Build Status](https://secure.travis-ci.org/rit-sse/alexandria.png?branch=master)](http://travis-ci.org/rit-sse/alexandria)
[![Dependency Status](https://gemnasium.com/rit-sse/alexandria.png)](https://gemnasium.com/rit-sse/alexandria)
[![Code Climate](https://codeclimate.com/github/rit-sse/alexandria.png)](https://codeclimate.com/github/rit-sse/alexandria)
[![Coverage Status](https://coveralls.io/repos/rit-sse/alexandria/badge.png?branch=master)](https://coveralls.io/r/rit-sse/alexandria?branch=master)

Library Management System by the Society of Software Engineers

Get started
-----------
1. Install Ruby
2. Make sure you have a supported JavaScript runtime installed.
  * If you are on Windows or Mac OS, or have node.js installed, you should be
    fine.
  * Otherwise, see the [list of supported runtimes](https://github.com/sstephenson/execjs#readme).
3. Install [Yaz](http://www.indexdata.dk/yaz/)
	* Make sure you did pass the `--enabled-shared` option to the configure
    script before building YAZ
4. Run `bundle install`
5. Run `rake db:migrate`
6. Run `rake db:seed`
7. If working on a branch with auth implemented, get the Google API keys from @kristenmills and insert them in the omniauth initializer (config/initializers/omniauth.rb)
8. Start solr: `rake sunspot:solr:start`
9. Start server: `rails s`

Solr
----
Solr is the search engine tool used in Alexandria. Once it is running, it will automatically index newly created book entries, but existing entries that are not indexed are ignored. Index entries manually by running `rake sunspot:reindex`.

Authentication
--------------
**Do not check config/initializers/omniauth.rb into the repo. Our Google API keys are in there for auth stuff. Just don't do it. Seriously.**
