require 'csv'

d = CSV.read(Rails.root.join("db", "data.csv"))
d.shift

d.each do |row|
	title = row[0]
	author = row[1]
	publish_date = Date.new(row[2].to_i,1,1)
	isbn = row[3]
	tags = row[4]
	tags = tags.split(", ") if tags != nil
	height_total = row[5]

	book = Book.new(
		:ISBN => isbn,
		:title => title,
		:publish_date => publish_date
	)

	book.save

	puts "Title: #{book.title}"
	puts "Author: #{book.author}"
	puts "----------------"
end