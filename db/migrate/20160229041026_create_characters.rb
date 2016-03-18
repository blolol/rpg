class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :level, null: false, default: 1
      t.string :role, null: false
      t.references :user, null: false, index: true
      t.integer :xp, null: false, default: 0
      t.timestamps null: false
    end
  end
end
