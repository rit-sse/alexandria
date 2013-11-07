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
      books = Book.where('lcc = ?', '')
      books.each do |book|
        book.get_lcc
        book.save
      end
      updated = books.select{ |i| i.lcc != '' }
      puts "Investigate: #{books.count}"
      puts "Updated:     #{updated.count}"
    end
  end
end
