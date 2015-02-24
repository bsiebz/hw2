class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings] == nil and params[:sort_by] == nil then
      unless session[:sort_by] == nil and session[:ratings] == nil 
        redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
      end
    end
    session[:sort_by] = (params[:sort_by] == nil)? session[:sort_by] : params[:sort_by]
    session[:ratings] = (params[:ratings] == nil)? session[:ratings] : params[:ratings]
    unless session[:sort_by] == nil then
      (session[:sort_by].eql? 'title')? @hilite_title = "hilite": @hilite_date = "hilite"
    end
    @movies = Movie.order(session[:sort_by])
    @all_ratings = Movie.list_of_ratings
    @selected_ratings = (session[:ratings] == nil) ?  Movie.list_of_ratings : session[:ratings].keys
    @movies = @movies.find(:all,:conditions => {:rating => @selected_ratings})
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
