class AddEnduringToItems < ActiveRecord::Migration[5.0]
  def change
    change_table :items do |t|
      t.boolean :enduring, null: false, default: false
    end
  end
end
