class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.references :character, null: false
      t.references :user, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
