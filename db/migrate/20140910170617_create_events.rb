class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :date
      t.string :location
      t.string :time
      t.string :venue
      t.string :url

      t.timestamps
    end
  end
end
