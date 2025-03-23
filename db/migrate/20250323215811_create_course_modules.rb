class CreateCourseModules < ActiveRecord::Migration[8.0]
  def change
    create_table :course_modules do |t|
      t.string :name
      t.text :description
      t.boolean :is_archived

      t.timestamps
    end
  end
end
