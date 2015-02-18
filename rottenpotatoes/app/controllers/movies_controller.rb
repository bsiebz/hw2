class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all(:select => :rating).map(&:rating).uniq
    @ratings = params[:ratings]
    @movies = Movie.all

    if @ratings != nil 
      keys = @ratings.keys
      @movies = Movie.where(:rating => keys)
      if params[:sort_by_title] == 'true'
        @movies = Movie.find(:all, :order => 'title').where(:rating => keys)
      elsif params[:sort_by_date] == 'true'
        @movies = Movie.find(:all, :order => 'release_date').where(:rating => keys)
      end
        return @movies
    end
    if params[:sort_by_title] == 'true'
      @movies = Movie.find(:all, :order => 'title').where(:rating => keys)
    elsif params[:sort_by_date] == 'true'
      @movies = Movie.find(:all, :order => 'release_date').where(:rating => keys)
    end
    return @movies
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
