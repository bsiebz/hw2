class AddFieldsToMovies < ActiveRecord::Migration
  create_table :movies
  def change
    add_column :movies, :title, :string
    add_column :movies, :release_date, :datetime
    add_column :movies, :rating, :string
    add_column :movies, :description, :text
  end
end
