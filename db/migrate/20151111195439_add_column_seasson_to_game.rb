class AddColumnSeassonToGame < ActiveRecord::Migration
  def change
    add_column :games, :game_number, :integer
    add_column :games, :seasson, :string
  end
end
