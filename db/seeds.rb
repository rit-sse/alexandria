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

d = d.first(5) if Rails.env == "development"

d.each do |row|
  titles = row[0].split(":")
  title = titles[0]
  subtitle = ""

  subtitle = titles[1] if titles.length > 1

  author = row[1]
  publish_date = Date.new(row[2].to_i,1,1)
  isbn = row[3]

  book = Book.new(
    isbn: isbn,
    title: title,
    subtitle: subtitle,
    publish_date: publish_date
  )

  author ||= ""

  author.split(",").each do |i|
    book.authors << Author.find_or_create(i)
  end
  book.save

  gbook = GoogleBookData.book_from_isbn(book.isbn)
  gbook.save

  gbook.book = book
  gbook.save

  puts "Title: #{book.title}"
  puts "Author: #{book.authors}"
  puts "ISBN: #{book.isbn}"
  puts "**** Google Book ****"
  puts book.google_book_data
  puts "Description: #{book.google_book_data.description[0..300]}"
  puts "================"

end
