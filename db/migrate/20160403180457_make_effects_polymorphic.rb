class MakeEffectsPolymorphic < ActiveRecord::Migration[5.0]
  def change
    add_reference :effects, :effectable, polymorphic: true, null: false, index: true
    remove_column :effects, :character_id, :integer, null: false, index: true
  end
end
