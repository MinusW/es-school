class AddIsArchivedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :is_archived, :boolean
  end
end
