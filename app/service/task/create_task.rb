# frozen_string_literal: true

module Task
  class CreateTask
    def initialize(task)
      @task = task
    end

    def create_task
      return unless @task.save

      schedule_mail_notification
      schedule_task_deletion
    end

    private

    def schedule_mail_notification
      TaskMailerWorker.perform_at((@task.due_date - 2.hours) - 10.minutes, @task.id)
    end

    def schedule_task_deletion
      DeleteTaskWorker.perform_at(@task.due_date + 3.days)
    end
  end
end
