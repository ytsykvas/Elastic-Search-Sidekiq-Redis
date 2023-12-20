class BooksController < ApplicationController
	def index
		if params[:query].present?
			@books = Book.search(params[:query]).paginate(page: params[:page], per_page: 20)
		else
			@books = Book.all.paginate(page: params[:page], per_page: 20)
		end
	end

	def search
		redirect_to books_path(query: params[:search][:query])
	end
end
