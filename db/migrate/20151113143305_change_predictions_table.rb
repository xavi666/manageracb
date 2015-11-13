class ChangePredictionsTable < ActiveRecord::Migration
  def change
    rename_table :table_predictions, :predictions
    add_column :predictions, :game_id, :integer
    add_column :games, :prediction_id, :integer
  end
end
