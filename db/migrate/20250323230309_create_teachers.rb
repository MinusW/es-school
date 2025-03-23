class CreateTeachers < ActiveRecord::Migration[8.0]
  def change
    create_table :teachers do |t|
      t.string :IBAN
      t.integer :state
      t.boolean :is_dean
      t.boolean :is_archived
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
