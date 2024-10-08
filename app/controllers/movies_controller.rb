class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]

  # GET /movies or /movies.json
  def index
    sort_column = params[:sort] || "title" # Default sort column
    sort_direction = params[:direction] || "asc" # Default sort direction

    # Use sanitized values to prevent SQL injection
    @movies = Movie.order("#{sanitize_sort_column(sort_column)} #{sanitize_sort_direction(sort_direction)}")
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end

    # Helper method to sanitize the sort column
    def sanitize_sort_column(column)
      allowed_columns = %w[title rating release_date] # Specify allowed columns
      allowed_columns.include?(column) ? column : "title"
    end

    # Helper method to sanitize the sort direction
    def sanitize_sort_direction(direction)
      %w[asc desc].include?(direction) ? direction : "asc"
    end
end
