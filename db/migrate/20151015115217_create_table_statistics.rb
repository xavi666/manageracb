class CreateTableStatistics < ActiveRecord::Migration
  def up
    create_table :statistics do |t|
      t.integer :player_id
      t.integer :team_id
      t.integer :team_against_id
      t.integer :game_number
      t.string :seasson

      t.integer :number
      t.integer :seconds, default: 0
      t.integer :points, default: 0
      t.integer :two_p, default: 0
      t.integer :two_pm, default: 0
      t.integer :three_p, default: 0
      t.integer :three_pm, default: 0
      t.integer :one_p, default: 0
      t.integer :one_pm, default: 0
      t.integer :rebounds, default: 0
      t.integer :orebounds, default: 0
      t.integer :drebounds, default: 0
      t.integer :assists, default: 0
      t.integer :steals, default: 0
      t.integer :turnovers, default: 0
      t.integer :fastbreaks, default: 0
      t.integer :mblocks, default: 0
      t.integer :rblocks, default: 0
      t.integer :mfaults, default: 0
      t.integer :rfaults, default: 0
      t.integer :positive_negative, default: 0
      t.integer :value, default: 0

      t.boolean :active, default: true
      t.timestamps
    end
  end

  def down
    drop_table :statistics
  end
end
