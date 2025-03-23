class CreateGrades < ActiveRecord::Migration[8.0]
  def change
    create_table :grades do |t|
      t.references :student, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.decimal :grade, precision: 4, scale: 1
      t.date :grading_date
      t.boolean :is_archived

      t.timestamps
    end
  end
end
