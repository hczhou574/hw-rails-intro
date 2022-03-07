class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
 
    
    def index
      @movies = Movie.all
      @all_ratings = Movie.all_ratings
      if params[:sort].in? %w[title]
        @hilite = "title"
        session[:filter_sort] = params[:sort]
        @movies = Movie.order(params[:sort]) 
      elsif params[:sort].in? %w[release_date]
        @hilite =  "release_date"
        session[:filter_sort] = params[:sort]
        @movies = Movie.order(params[:sort])
      else
        if session[:filter_sort]!=nil
          @movies = Movie.order(session[:filter_sort])
          @hilite = session[:filter_sort]
        end
      end
      if params[:ratings] != nil
        session[:filter_rating] = params[:ratings]
        @ratings_to_show = params[:ratings].keys
        @movies = Movie.with_ratings(@ratings_to_show, session[:filter_sort])
      else 
        if session[:filter_rating] != nil
          @ratings_to_show = session[:filter_rating].keys
          @movies = Movie.with_ratings(@ratings_to_show, session[:filter_sort])
        end
      end
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end