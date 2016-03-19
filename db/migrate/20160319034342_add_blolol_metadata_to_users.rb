class AddBlololMetadataToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.json :blolol_metadata
      t.datetime :blolol_metadata_updated_at
    end
  end
end
