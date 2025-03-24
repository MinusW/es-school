class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :weekday
      t.references :quarter, null: false, foreign_key: true
      t.references :theme, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.boolean :is_archived

      t.timestamps
    end
  end
end
