class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :name
      t.text :description
      t.float :price
      t.string :manufacturer
      t.binary :image

      t.timestamps
    end
  end
end
