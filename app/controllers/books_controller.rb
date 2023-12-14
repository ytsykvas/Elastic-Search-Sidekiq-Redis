class BooksController < ApplicationController
	def index
		@books = Book.all.paginate(page: params[:page], per_page: 20)
	end
end
