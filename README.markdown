Alexandria
==========

Library Management System by the Society of Software Engineers

Get started
-----------
1. Install Ruby
2. Run `bundle install`
3. Start solr: `rake sunspot:solr:start`

Solr
----
Solr is the search engine tool used in Alexandria. Once it is running, it will automatically index newly created book entries, but existing entries that are not indexed are ignored. Index entries by running `rake sunspot:reindex`.