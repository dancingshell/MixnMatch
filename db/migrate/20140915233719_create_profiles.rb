class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.text :summary
      t.string :orientation
      t.string :gender
      t.string :birth_m
      t.integer :birth_d
      t.integer :birth_y
      t.boolean :relationship
      t.boolean :friedship
      t.integer :zipcode
      t.references :user, index: true

      t.timestamps
    end
  end
end
