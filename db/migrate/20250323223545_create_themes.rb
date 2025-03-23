class CreateThemes < ActiveRecord::Migration[8.0]
  def change
    create_table :themes do |t|
      t.string :module_name
      t.text :module_description
      t.boolean :is_archived

      t.timestamps
    end
  end
end
