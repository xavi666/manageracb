class AddPlayedGamesToStatistic < ActiveRecord::Migration
  def change
    add_column :statistics, :played_games, :integer, default: 0
  end
end
