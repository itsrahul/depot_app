class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      # t.integer :parent_id, default: :null, null:true
      t.references :parent
      t.string  :name
      t.integer :products_count, default: 0, null: false
      t.timestamps
    end
  end
end
