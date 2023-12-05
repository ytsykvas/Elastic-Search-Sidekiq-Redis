# frozen_string_literal: true

class TaskMailer < ApplicationMailer
  def notify_due_date(task)
    @task = task
    mail(to: 'tsykvasyurii@gmail.com', subject: 'Task Due Date Reminder')
  rescue StandardError => e
    Rails.logger.error("Error sending due date notification email: #{e.message}")
  end
end
