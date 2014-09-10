class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :match, index: true
      t.string :content

      t.timestamps
    end
  end
end
