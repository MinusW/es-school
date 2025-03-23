class CreateClassTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :class_types do |t|
      t.string :name
      t.text :description
      t.boolean :is_archived

      t.timestamps
    end
  end
end
