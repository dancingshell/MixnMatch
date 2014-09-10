class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :matcher, index: true
      t.references :matchee, index: true
      t.string :type

      t.timestamps
    end
  end
end
