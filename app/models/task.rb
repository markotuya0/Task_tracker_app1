class Task < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :due_date, presence: true
  
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :upcoming, -> { where("due_date >= ?", Date.today).order(due_date: :asc) }
  scope :overdue, -> { where("due_date < ? AND completed = ?", Date.today, false).order(due_date: :asc) }
end
