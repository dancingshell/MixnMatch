class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :event, index: true

      t.timestamps
    end
  end
end
