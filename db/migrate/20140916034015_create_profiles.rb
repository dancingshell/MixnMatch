class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.text :summary
      t.string :orientation
      t.string :gender
      t.date :birthday
      t.boolean :relationship
      t.boolean :friendship
      t.integer :zipcode
      t.references :user, index: true

      t.timestamps
    end
  end
end
