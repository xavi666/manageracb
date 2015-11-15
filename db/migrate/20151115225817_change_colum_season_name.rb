class ChangeColumSeasonName < ActiveRecord::Migration
  def change
    rename_column :statistics, :seasson, :season
    rename_column :games, :seasson, :season
  end
end
