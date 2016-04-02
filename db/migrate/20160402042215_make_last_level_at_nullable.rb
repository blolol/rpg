class MakeLastLevelAtNullable < ActiveRecord::Migration[5.0]
  def up
    change_column_null :characters, :last_level_at, true
    change_column_default :characters, :last_level_at, nil
  end

  def down
    execute <<-SQL
      ALTER TABLE characters
      ALTER COLUMN last_level_at
      SET DEFAULT CURRENT_TIMESTAMP
    SQL

    change_column_null :characters, :last_level_at, false
  end
end
