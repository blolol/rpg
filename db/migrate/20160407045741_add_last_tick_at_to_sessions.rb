class AddLastTickAtToSessions < ActiveRecord::Migration[5.0]
  def up
    add_column :sessions, :last_tick_at, :datetime
    execute 'UPDATE sessions SET last_tick_at = updated_at'
  end

  def down
    remove_column :sessions, :last_tick_at
  end
end
