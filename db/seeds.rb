# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

d = CSV.read(Rails.root.join('db', 'data.csv'))
d.shift

d = d.first(25) if Rails.env == "development"

d.each do |row|
  book = Book.add_by_isbn(row[3])

  if book.title.nil?
    titles = row[0].split(':')
    book.title = titles[0]
    book.subtitle = titles[1] || ''

    author = row[1]
    author.split(",").each do |i|
      book.authors << Author.find_or_create(i)
    end
    book.publish_date = Date.new(row[2].to_i, 1, 1)
    book.save
  end

  puts "Title: #{book.title}"
  puts "Author: #{book.authors}"
  puts "ISBN: #{book.isbn}"
  puts "LCC: #{book.lcc}"
  puts "================"
end

Role.create(name: 'patron')
Role.create(name: 'distributor')
Role.create(name: 'librarian')
Role.create(name: 'technical admin')

Reason.create(message: 'Overdue book')
Reason.create(message: 'Damaged book')
Reason.create(message: 'Other')

