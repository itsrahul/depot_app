class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :value, precision: 4, scale: 2, null: false


      t.timestamps
    end
  end
end
