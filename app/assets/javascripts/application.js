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
				url: "/books.json",
				data: {"search": query}
			}).done(function( data ){
				if(!data[0]){
					data = [{
						title: "No results found",
						id: "none",
						none: true
					}]
				} else if(data.length > 8){
					data[8] = {
						title: "More results",
						id: "more",
						more: true
					}
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
			if(item.toString() != "none" && item.toString() != "more"){
				window.location = window.location.origin + "/books/" + item
			}
			if(item.toString() == "more" || item.toString() == "none"){
				window.location = window.location.origin + "/books?search=" +
					$("#master-search")[0].value;
			}
		},
		minLength: 3,
		items: 9
	})
});