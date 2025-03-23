class CreateClassrooms < ActiveRecord::Migration[8.0]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.integer :class_type_id
      t.integer :room_id
      t.integer :teacher_id
      t.boolean :is_archived

      t.timestamps
    end
  end
end
