class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: true, foreign_key: true
      t.string :city
      t.string :state
      t.string :country
      t.integer :pincode

      t.timestamps
    end
  end
end
