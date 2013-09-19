Alexandria
==========
[![Build Status](https://secure.travis-ci.org/rit-sse/alexandria.png?branch=master)](http://travis-ci.org/rit-sse/alexandria)
[![Dependency Status](https://gemnasium.com/rit-sse/alexandria.png)](https://gemnasium.com/rit-sse/alexandria)
[![Code Climate](https://codeclimate.com/github/rit-sse/alexandria.png)](https://codeclimate.com/github/rit-sse/alexandria)


Library Management System by the Society of Software Engineers

Get started
-----------
1. Install Ruby
2. Run `bundle install`
3. If working on a branch with auth implemented, get the Google API keys from @kristenmills and insert them in the omniauth initializer (config/initializers/omniauth.rb)
4. Start solr: `rake sunspot:solr:start`
5. Start server: `rails s`

Solr
----
Solr is the search engine tool used in Alexandria. Once it is running, it will automatically index newly created book entries, but existing entries that are not indexed are ignored. Index entries manually by running `rake sunspot:reindex`.

Authentication
--------------
**Do not check config/initializers/omniauth.rb into the repo. Our Google API keys are in there for auth stuff. Just don't do it. Seriously.**
