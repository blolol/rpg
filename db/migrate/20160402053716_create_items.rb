class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :character, null: false, index: true
      t.integer :level, null: false
      t.string :name, limit: 255, null: false
      t.string :rarity, limit: 255, null: false
      t.string :slot, limit: 255, null: false
    end
  end
end
