class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :building
      t.integer :floor
      t.integer :capacity
      t.boolean :is_archived

      t.timestamps
    end
  end
end
