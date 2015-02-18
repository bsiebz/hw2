class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all(:select => :rating).map(&:rating).uniq
    @ratings = Array.new
    @movies = Movie.all
    @sort = nil

    if session.has_key?(:prev_ratings)
      @ratings = session[:prev_ratings]
    end

    if !params.has_key?(:sort_by)
      if session.has_key?(:prev_sort_by)
        @sort = session[:prev_sort_by]
        params[:sort_by] = @sort
    else
      @sort = params[:sort_by]
      session[:prev_sort_by] = @sort
    end
    
    if params[:ratings] != nil 
      @ratings = params[:ratings].keys
      session[:prev_ratings] = @ratings
      @movies = Movie.where(:rating => @ratings)
      if @sort != nil
        @movies = Movie.order(@sort).where(:rating => @ratings)
      end
      return @movies
    elsif params[:ratings] == nil && session[:prev_ratings] != nil
      if @sort != nil
        @movies = Movie.order(@sort).where(:rating => @ratings)
      end
      return @movies
    end
    
    if @sort != nil
      @movies = Movie.find(:all, :order => @sort)
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
