// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require handlebars.js
//= require_tree ./templates
//= require twitter/bootstrap
//= require_tree .

var a;
var b;

$(document).ready(function(){
	$("#master-search").typeahead({
		source: function(query, process){
			$.ajax({
				url: "/books/search.json",
				data: {"query": query}
			}).done(function( data ){
				if(!data[0]){
					data = [{
						title: "No results found",
						id: -1
					}]
				}
				process( data );	
			})
			
		},
		matcher: function(item){
			item.toString = function(){return item.id};
			return true;
		},
		sorter: function(item){
			return item;
		},
		highlighter: function(item){
			return HandlebarsTemplates['search-item']({item: item});
		},
		updater: function(item){
			if(item.toString() != "-1"){
				window.location = window.location.origin + "/books/" + item
			}
		},
		minLength: 3
	})
});