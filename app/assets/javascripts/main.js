if (!window.location.origin) window.location.origin = window.location.protocol+"//"+window.location.host;

$(document).ready(function(){
	$("#master-search").typeahead({
		source: function(query, process){
			$.ajax({
				url: "/books.json",
				data: {
					"search": query,
					"limit": 9
				}
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

	$("#isbn-add").focus();
});
