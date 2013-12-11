# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

unless Rails.env  == "production"
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
else
  csv = CSV.read(Rails.root.join('db', 'books.csv'))
  csv.shift

  csv.each do |row|
    book = Book.new
    book.title = row[0]
    book.subtitle = row[1] || ''
    (row[2] || '').split(', ').each do |author|
      book.authors << Author.find_or_create(author)
    end
    book.isbn = row[3]
    book.lcc = Book.normalize(row[4])
    begin
      book.publish_date = Date.parse(row[5])
    rescue
      unless row[5].blank?
        book.publish_date = Date.new(row[5].to_i)
      end
    end
    gb = GoogleBookData.new
    gb.description = row[6] || ''
    gb.img_thumbnail = row[7] || ''
    gb.img_small = row[8] || ''
    gb.img_medium = row[9] || ''
    gb.img_large = row[10] || ''
    gb.preview_link = row[11] || ''
    gb.book = book
    gb.save
    book.save

    puts "Title: #{book.title}"
    puts "ISBN: #{book.isbn}"
    puts "LCC: #{book.lcc}"
    puts "================"
  end
end

Role.create(name: 'patron')
Role.create(name: 'distributor')
Role.create(name: 'librarian')
Role.create(name: 'technical admin')

Reason.create(message: 'Overdue book')
Reason.create(message: 'Damaged book')
Reason.create(message: 'Other')

