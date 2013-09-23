namespace :books do
	desc "Updates books with no data"
	task update: :environment do
		books = GoogleBookData.update_all_null
		updated = books.find_all{|i| i.description != ""}
		puts "Investigated: #{books.count}"
		puts "Updated:      #{updated.count}"
	end
end
