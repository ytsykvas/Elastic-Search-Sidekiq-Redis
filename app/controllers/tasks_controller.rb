# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(due_date: :asc).paginate(page: params[:page], per_page: 5)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    task_service = ::Task::CreateTask.new(@task)

    if task_service.create_task
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def destroy
    if set_task.destroy
      redirect_to tasks_path, notice: 'Task was successfully deleted.'
    else
      redirect_to tasks_path, alert: 'Error deleting task.'
    end
  end

  def mark_done
    ::Task::ChangeTaskStatus.new(set_task).call
    redirect_to tasks_path, notice: 'Task status successfully changed.'
  rescue StandardError => e
    redirect_to tasks_path, alert: "Error marking task as done: #{e.message}"
  end

  private

  def set_task
    @set_task ||= Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_date)
  end
end
