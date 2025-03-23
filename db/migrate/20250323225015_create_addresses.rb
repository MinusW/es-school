class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :city
      t.string :npa
      t.string :street
      t.string :house
      t.string :apartment_number

      t.timestamps
    end
  end
end
