# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

d = CSV.read(Rails.root.join("db", "data.csv"))
d.shift

if Rails.env == "development"
	d = d.first(5)
end

d.each do |row|
	titles = row[0].split(":")
	title = titles[0]
	subtitle = ""

	if(titles.length > 1)
		subtitle = titles[1]
	end


	author = row[1]
	publish_date = Date.new(row[2].to_i,1,1)
	isbn = row[3]
	tags = row[4]
	tags = tags.split(", ") if tags != nil
	height_total = row[5]

	book = Book.new(
		:ISBN => isbn,
		:title => title,
		:subtitle => subtitle,
		:publish_date => publish_date
	)

	author ||= ""

	author.split(",").each do |i|
		book.author << Author.find_or_create(i)
	end
	book.save

	gbook = GoogleBookData.book_from_isbn(book.ISBN)
	gbook.save
	
	gbook.book = book
	gbook.save


	puts "Title: #{book.title}"
	puts "Author: #{book.author}"
	puts "ISBN: #{book.ISBN}"
	puts "**** Google Book ****"
	puts book.google_book_data
	puts "Description: #{book.google_book_data.description[0..300]}"
	puts "================"

end