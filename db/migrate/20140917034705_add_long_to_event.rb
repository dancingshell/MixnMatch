class AddLongToEvent < ActiveRecord::Migration
  def change
    add_column :events, :long, :decimal, :precision => 15, :scale => 10, :default => 0.0
  end
end
