class ChangeColumnNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :counters, :url, false
  end
end
