class AddLastLevelAtToCharacters < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      ALTER TABLE characters
      ADD last_level_at timestamp
      DEFAULT CURRENT_TIMESTAMP
      NOT NULL
    SQL
  end

  def down
    remove_column :characters, :last_level_at
  end
end
