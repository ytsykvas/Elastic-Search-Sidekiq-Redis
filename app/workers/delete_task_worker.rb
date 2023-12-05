# frozen_string_literal: true

class DeleteTaskWorker
  include Sidekiq::Job

  def perform(task_id)
    task = Task.find(task_id)
    process_task(task)
  rescue ActiveRecord::RecordNotFound => e
    handle_record_not_found(task_id, e)
  rescue StandardError => e
    handle_standard_error(task_id, e)
  end

  private

  def process_task(task)
    if task.exists? && task.status != 'DONE'
      update_task_overdue(task)
    elsif task.exists?
      destroy_task(task)
    end
  end

  def update_task_overdue(task)
    task.update!(status: 'OVERDUE')
    DeleteTaskWorker.perform_at(task.due_date + 3.days)
  end

  def destroy_task(task)
    task.destroy
  end

  def handle_record_not_found(task_id, error)
    Rails.logger.error("Task with id=#{task_id} not found: #{error.message}")
  end

  def handle_standard_error(task_id, error)
    Rails.logger.error("An error occurred while deleting task with id=#{task_id}: #{error.message}")
  end
end
