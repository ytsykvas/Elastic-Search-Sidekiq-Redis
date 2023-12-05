# frozen_string_literal: true

module Task
  class ChangeTaskStatus
    def initialize(task)
      @task = task
    end

    def call
      raise ArgumentError, 'Task cannot be nil' if @task.nil?

      begin
        @task.status == 'TO DO' ? @task.update!(status: 'DONE') : @task.update!(status: 'TO DO')
      rescue ActiveRecord::RecordInvalid => e
        raise StandardError, "Failed to mark done: #{e.message}"
      end
    end
  end
end
