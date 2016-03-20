class AddXpPenaltyToCharacters < ActiveRecord::Migration[5.0]
  def change
    change_table :characters do |t|
      t.integer :xp_penalty, null: false, default: 0
    end
  end
end
