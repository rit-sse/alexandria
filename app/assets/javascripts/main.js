// window.location.origin = window.location.protocol + "//" + window.location.host  unless window.location.origin

$(document).ready(function() {
  $("#master-search").typeahead([{
    remote: '/books.json?search=%QUERY',
    name: 'search',
    valueKey: 'title',
    template: function(item) {
      return HandlebarsTemplates['search-item']({item: item});
    },
    engine: Handlebars
  }]).on('typeahead:selected', onSelected);

  function onSelected($e, datum){
  	window.location = window.location.origin + "/books/" + datum.id;
  }

  $("#master-search").keyup(function (event){
  	if(event.keyCode == 13){
  		window.location = window.location.origin + "/books/?search=" + $("#master-search").val();
  	}
  });
});

$("#isbn-add").focus()
