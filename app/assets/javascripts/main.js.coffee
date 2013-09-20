window.location.origin = window.location.protocol + "//" + window.location.host  unless window.location.origin

$(document).ready ->
  $("#master-search").typeahead
    source: (query, process) ->
      $.ajax(
        url: "/books.json"
        data:
          search: query
          limit: 9
      ).done (data) ->
        unless data[0]
          data = [
            title: "No results found"
            id: "none"
            none: true
          ]
        else if data.length > 8
          data[8] =
            title: "More results"
            id: "more"
            more: true
        process data

    matcher: (item) ->
      item.toString = ->
        item.id

      true

    sorter: (item) ->
      item

    highlighter: (item) ->
      HandlebarsTemplates["search-item"] item: item

    updater: (item) ->
      window.location = window.location.origin + "/books/" + item  if item.toString() isnt "none" and item.toString() isnt "more"
      window.location = window.location.origin + "/books?search=" + $("#master-search")[0].value  if item.toString() is "more" or item.toString() is "none"

    minLength: 3

    items: 9

  $("#isbn-add").focus()
