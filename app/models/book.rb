class Book < ApplicationRecord
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	validates :title, presence: true
	validates :author, presence: true
	validates :published_year, presence: true
	validates :excerpt, presence: true

	def as_indexed_json(_options = {})
		as_json(only: %w[title author published_year])
	end

	def self.search(query)
		__elasticsearch__.search(
			{
				query: {
					multi_match: {
						query: query,
						fields: %w[title^10 author^5 excerpt]
					}
				}
			}
		)
	end

	settings index: { number_of_shards: 1 } do
		mappings dynamic: 'false' do
			indexes :title, analyzer: 'english', index_options: 'offsets'
			indexes :author, analyzer: 'english', index_options: 'offsets'
			indexes :published_year, type: 'integer'
			indexes :excerpt, analyzer: 'english', index_options: 'offsets'
		end
	end
end
