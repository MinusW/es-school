class CreateQuarters < ActiveRecord::Migration[8.0]
  def change
    create_table :quarters do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :is_archived

      t.timestamps
    end
  end
end
