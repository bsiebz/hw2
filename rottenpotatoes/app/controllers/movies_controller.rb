class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all(:select => :rating).map(&:rating).uniq
    @rating_array = Array.new
    @movies = Movie.all
    @sort = nil

    if params[:ratings] != nil
      @rating_array = params[:ratings].keys
      session[:prev_ratings] = @rating_array
    elsif session[:prev_ratings] != nil
      @rating_array = session[:prev_ratings]
      params[:ratings] = @rating_array
    else
      @rating_array = @all_ratings
    end

    if params.has_key?(:sort_by)
      @sort = params[:sort_by]
      session[:prev_sort_by] = @sort
    elsif session.has_key?(:prev_sort_by)
      @sort = session[:prev_sort_by]
      params[:sort_by] = @sort
    else
      @sort = nil
    end


    if @sort == "title"
      @movies = Movie.order('title').where(:rating => @rating_array)
    elsif @sort == "release_date"
      @movies = Movie.order('release_date').where(:rating => @rating_array)
    else
      @movies = Movie.where(:rating => @rating_array)
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
