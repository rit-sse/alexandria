require 'csv'

d = CSV.read(Rails.root.join("db", "data.csv"))
d.shift

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

	puts "Title: #{book.title}"
	puts "Author: #{book.author}"
	puts "----------------"
end