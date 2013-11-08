require 'zoom'
require 'marc'
require 'stringio'

namespace :books do
	desc "Updates books with no data"
	task update: :environment do
		books = GoogleBookData.update_all_null
		updated = books.find_all{|i| i.description != ""}
		puts "Investigated: #{books.count}"
		puts "Updated:      #{updated.count}"
	end

  namespace :lcc do
    desc "Updates lcc manually for books without them"
    task manual: :environment do
      books = Book.where('lcc = ?', '')
      books.each do |book|
        puts "Title: #{book.title}"
        puts "ISBN: #{book.isbn}"
        lcc = ask('LCC for this book is:')
        book.lcc = lcc.strip
        book.save
      end
    end

    desc "Updates lcc from the database for books without them"
    task auto: :environment do
      books = Book.where('lcc = ?', '').to_a
      ZOOM::Connection.open('z3950.loc.gov', 7090) do |conn|
        conn.database_name = 'VOYAGER'
        conn.preferred_record_syntax = 'USMARC'
        books.each do |book|
          conn.search("@attr 1=7 #{book.isbn}").each_record do |item|
            MARC::Reader.new(StringIO.new(item.raw)).each do |rec|
              book.set_lcc(rec)
              book.save
            end
          end
        end
      end
      updated = books.select{ |i| i.lcc != '' }
      puts "Investigate: #{books.count}"
      puts "Updated:     #{updated.count}"
    end
  end
end
