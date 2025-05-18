class AddUserToTasks < ActiveRecord::Migration[7.2]
  def change
    add_reference :tasks, :user, null: true, foreign_key: true
    
    # Set default value for completed field if it's not already set
    change_column_default :tasks, :completed, false
  end
end