class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  impressionist :actions => [:show]
  respond_to :js, :html

  # GET /instructors
  # GET /instructors.json
  def index
    @pagy, @instructors = pagy(Instructor.order(name: :asc), items: 25)
    authorize @instructors
  end

  def search
    authorize Instructor
    @pagy, @instructor_search = pagy(
      Instructor.ransack(
        name_cont: params[:instructor_search],
        nickname_cont: params[:instructor_search],
        description_cont: params[:instructor_search],
        instagram_cont: params[:instructor_search],
        youtube_cont: params[:instructor_search],
        twitter_cont: params[:instructor_search],
        facebook_cont: params[:instructor_search],m:'or'
        ).result(distinct: true), 
      items:25, 
      link_extra: 'data-remote="true"'
    )
    respond_to do |format|
      format.js
    end
  end

  # GET /instructors/1
  # GET /instructors/1.json
  def show
    authorize @instructor
  end

  # GET /instructors/new
  def new
    @instructor = Instructor.new
    authorize @instructor
  end

  # GET /instructors/1/edit
  def edit
    authorize @instructor
  end

  # POST /instructors
  # POST /instructors.json
  def create
    @instructor = Instructor.new(instructor_params)
    authorize @instructor

    respond_to do |format|
      if @instructor.save
        format.html { redirect_to instructors_path, notice: 'Instructor was successfully created.' }
        format.json { render :show, status: :created, location: @instructor }
      else
        format.html { render :new }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instructors/1
  # PATCH/PUT /instructors/1.json
  def update
    authorize @instructor
    respond_to do |format|
      if @instructor.update(instructor_params)
        format.html { redirect_to @instructor, notice: 'Instructor was successfully updated.' }
        format.json { render :show, status: :ok, location: @instructor }
      else
        format.html { render :edit }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instructors/1
  # DELETE /instructors/1.json
  def destroy
    authorize @instructor
    @instructor.destroy
    respond_to do |format|
      format.html { redirect_to instructors_url, notice: 'Instructor was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instructor_params
      params.require(:instructor).permit(:name, :nickname, :description, :instagram, :youtube, :twitter, :facebook)
    end
end
