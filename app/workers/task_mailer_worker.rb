# frozen_string_literal: true

class TaskMailerWorker
  include Sidekiq::Job

  def perform(task_id)
    task = Task.find(task_id)
    TaskMailer.notify_due_date(task).deliver_now
  end
end
