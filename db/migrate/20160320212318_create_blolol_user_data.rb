class CreateBlololUserData < ActiveRecord::Migration[5.0]
  def down
    add_column :users, :blolol_metadata, :json
    add_column :users, :blolol_metadata_updated_at, :datetime

    migrate_user_data_down

    drop_table :blolol_user_data
  end

  def up
    create_table :blolol_user_data do |t|
      t.references :user, null: false, index: { unique: true }
      t.string :blolol_id, limit: 255, null: false
      t.string :roles, array: true, default: [], limit: 255
      t.string :username, limit: 255, null: false
      t.timestamps
    end

    migrate_user_data_up

    remove_column :users, :blolol_metadata_updated_at
    remove_column :users, :blolol_metadata
  end

  private

  def migrate_user_data_down
    execute <<-SQL
      UPDATE users
      SET
        blolol_metadata = json_build_object(
          'id', blolol_user_data.blolol_id,
          'roles', blolol_user_data.roles,
          'username', blolol_user_data.username
        ),
        blolol_metadata_updated_at = blolol_user_data.updated_at
      FROM blolol_user_data
      WHERE blolol_user_data.user_id = users.id
    SQL
  end

  def migrate_user_data_up
    execute <<-SQL
      INSERT INTO blolol_user_data (user_id, blolol_id, roles, username, created_at, updated_at)
      SELECT
        users.id,
        users.blolol_metadata->>'id',
        ARRAY(SELECT json_array_elements_text(users.blolol_metadata->'roles')),
        users.blolol_metadata->>'username',
        LOCALTIMESTAMP,
        users.blolol_metadata_updated_at
      FROM users
      WHERE users.blolol_metadata IS NOT NULL
    SQL
  end
end
