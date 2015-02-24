class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  def self.list_of_ratings
    Movie.pluck(:rating).uniq
  end
end
