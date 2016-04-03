class AddMetadataToEffects < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore'

    change_table :effects do |t|
      t.hstore :metadata, null: false, default: {}
    end
  end
end
