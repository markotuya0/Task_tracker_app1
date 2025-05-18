class TasksController < ApplicationController
  before_action :check_setup_mode
  before_action :set_task, only: %i[ show edit update destroy toggle_complete ]

  # GET /tasks or /tasks.json
  def index
    if @setup_mode
      @tasks = []
      @overdue_tasks = []
      @upcoming_tasks = []
      flash.now[:alert] = "Application is in setup mode. Please complete Devise initialization."
    else
      @tasks = current_user.tasks.incomplete.order(due_date: :asc)
      @overdue_tasks = current_user.tasks.overdue
      @upcoming_tasks = current_user.tasks.upcoming.incomplete
    end
  end

  # GET /tasks/completed
  def completed
    if @setup_mode
      @tasks = []
      flash.now[:alert] = "Application is in setup mode. Please complete Devise initialization."
    else
      @tasks = current_user.tasks.completed.order(updated_at: :desc)
    end
    render :completed
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    if @setup_mode
      redirect_to tasks_path, alert: "Cannot create tasks in setup mode."
    else
      @task = current_user.tasks.build
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /tasks/1/toggle_complete
  def toggle_complete
    @task.update(completed: !@task.completed)
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: tasks_path, notice: "Task status updated.") }
      format.json { render :show, status: :ok, location: @task }
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@task) }
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Check if application is in setup mode
    def check_setup_mode
      @setup_mode = !defined?(current_user)
      redirect_to root_path, alert: "Application is in setup mode. Please complete Devise initialization." if @setup_mode && !action_name.in?(['index', 'completed'])
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      return if @setup_mode
      @task = current_user.tasks.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :completed, :due_date)
    end
end
