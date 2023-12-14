class Book < ApplicationRecord
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	validates :title, presence: true
	validates :author, presence: true
	validates :published_year, presence: true

	def as_indexed_json(_options = {})
		as_json(only: %w[title author published_year])
	end
end
