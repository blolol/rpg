class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :owner, null: false, index: true
      t.string :character_class, null: false
      t.integer :level, null: false, default: 1
      t.integer :xp, null: false, default: 0
      t.timestamps null: false

      t.index %i(name owner)
    end
  end
end
