class CreateEffects < ActiveRecord::Migration[5.0]
  def change
    create_table :effects do |t|
      t.references :character, null: false, index: true
      t.string :type, null: false
      t.timestamps
    end
  end
end
