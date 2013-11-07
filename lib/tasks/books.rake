namespace :books do
	desc "Updates books with no data"
	task update: :environment do
		books = GoogleBookData.update_all_null
		updated = books.find_all{|i| i.description != ""}
		puts "Investigated: #{books.count}"
		puts "Updated:      #{updated.count}"
	end

  desc "Updates lcc for books without them"
  task lcc: :environment do
    books = Book.where('lcc = ?', '')
    books.each do |book|
      puts "Title: #{book.title}"
      puts "ISBN: #{book.isbn}"
      lcc = ask('LCC for this book is:')
      book.lcc = lcc.strip
      book.save
    end
  end
end
