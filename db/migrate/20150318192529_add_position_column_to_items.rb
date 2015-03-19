class AddPositionColumnToItems < ActiveRecord::Migration
  def change
    add_column :items, :position, :integer, index: true
  end
end
