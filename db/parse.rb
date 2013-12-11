require 'csv'
require 'googlebooks'

rows = CSV.read('isbn-lcc.csv')
rows.shift

CSV.open('books.csv', 'wb') do |csv|
  csv << ['Title', 'Subtitle', 'Authors', 'ISBN', 'LCC', 'Publish Date', 'Description', 'Thumbnail', 'Small', 'Medium', 'Large', 'Preview']
  rows.each do |row|
    isbn = row[0]
    lcc = row[1]
    gb = GoogleBooks.search("isbn:#{isbn}", { api_key: ENV['ALEXANDRIA_SIMPLE'] }).first
    unless gb.nil?
      titles = gb.titles_array
      title = titles[0]
      subtitle = titles[1] || ''
      authors = gb.authors || ''
      publish_date = gb.published_date
      description   = gb.description.gsub('"', '') unless gb.description.nil?
      img_thumbnail = gb.image_link(zoom: 5)
      img_small     = gb.image_link
      img_medium    = gb.image_link(zoom: 2)
      img_large     = gb.image_link(zoom: 3)
      preview_link  = gb.preview_link
    end
    csv << [title, subtitle, authors, isbn, lcc, publish_date, description, img_thumbnail, img_small, img_medium, img_large, preview_link]
    puts "**********************"
    puts "Title: #{title}"
    puts "Subtitle: #{subtitle}"
    puts "Authors: #{authors}"
    puts "ISBN: #{isbn}"
    puts "LCC: #{lcc}"
    puts "Publish Date: #{publish_date}"
    puts "**********************"
    sleep(0.5)
  end
end