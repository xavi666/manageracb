class CreateTableStatistics < ActiveRecord::Migration
  def up
    create_table :statistics do |t|
      t.integer :player_id
      t.integer :visitant_team_id
      t.integer :local_team_id

      t.integer :number
      t.integer :seconds
      t.integer :points
      t.integer :two_p
      t.integer :two_pm
      t.integer :three_p
      t.integer :three_pm
      t.integer :one_p
      t.integer :one_pm
      t.integer :rebounds
      t.integer :orebounds
      t.integer :drebounds
      t.integer :assists
      t.integer :steals
      t.integer :turnovers
      t.integer :fastbreaks
      t.integer :mblocks
      t.integer :rbllocks
      t.integer :mfaults
      t.integer :rfaults
      t.integer :positive_negative
      t.integer :value

      t.boolean :active, default: true
      t.timestamps
    end
  end

  def down
    drop_table :statistics
  end
end
