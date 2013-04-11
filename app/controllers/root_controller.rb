class RootController < ApplicationController
	def index
		@books = (100..102).to_a.map do |i|
			Book.find(i)
		end
	end
end