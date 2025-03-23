class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.references :user, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true
      t.integer :state
      t.boolean :is_archived

      t.timestamps
    end
    add_index :students, :is_archived
  end
end
