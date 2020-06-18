class CreateCounters < ActiveRecord::Migration[6.0]
  def change
    create_table :counters do |t|
      t.string :url
      t.integer :count, default: 0

      t.timestamps
    end
  end
end
