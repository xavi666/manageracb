class AddThreePmToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :three_pm, :integer
  end
end
