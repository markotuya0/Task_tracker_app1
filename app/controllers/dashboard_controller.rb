class DashboardController < ApplicationController
  # No authentication required for now
  
  def index
    # Temporarily provide a simple view without requiring authentication
    if defined?(current_user) && current_user
      @overdue_tasks = current_user.tasks.overdue
      @today_tasks = current_user.tasks.where(due_date: Date.today).incomplete
      @upcoming_tasks = current_user.tasks.upcoming.incomplete.where("due_date > ?", Date.today).limit(5)
      @completed_tasks = current_user.tasks.completed.order(updated_at: :desc).limit(5)
      @total_tasks = current_user.tasks.count
      @completed_count = current_user.tasks.completed.count
      @completion_rate = @total_tasks > 0 ? (@completed_count.to_f / @total_tasks * 100).round : 0
    else
      # Provide empty collections when not authenticated
      @overdue_tasks = []
      @today_tasks = []
      @upcoming_tasks = []
      @completed_tasks = []
      @total_tasks = 0
      @completed_count = 0
      @completion_rate = 0
    end
  end
end