// window.location.origin = window.location.protocol + "//" + window.location.host  unless window.location.origin

$(document).ready(function() {
  $('.datepicker').datepicker({
    format: 'yyyy-mm-dd'
  });
  $("#master-search").typeahead([{
    limit: 6,
    remote: {
        url: "/books.json?search=%QUERY&limit=5",
        filter: function( data ){
        if(!data[0]){
          data = [{
            title: $("#master-search")[0].value,
            id: "none",
            none: true
          }]
        } else if(data.length > 5){
          data[5] = {
            title: $("#master-search")[0].value,
            id: "more",
            more: true
          }
        }
        return data;
      }
    },
    name: 'search',
    valueKey: 'title',
    template: function(item) {
      return HandlebarsTemplates['search-item']({item: item});
    },
    engine: Handlebars
  }]).on('typeahead:selected', onSelected);

  function onSelected($e, datum){
     if(datum.id != "none" && datum.id != "more"){
        window.location = window.location.origin + "/books/" + datum.id
      }
      if(datum.id == "more" || datum.id == "none"){
        window.location = window.location.origin + "/books?search=" +
          $("#master-search")[0].value;
      }
  }

  $("#master-search").keyup(function (event){
  	if(event.keyCode == 13){
  		window.location = window.location.origin + "/books/?search=" + $("#master-search").val();
  	}
  });
});

$("#isbn-add").focus()

