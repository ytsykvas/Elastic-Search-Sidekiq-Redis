class AddExcerptToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :excerpt, :text
  end
end
