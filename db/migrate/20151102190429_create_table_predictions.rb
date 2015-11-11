class CreateTablePredictions < ActiveRecord::Migration
  def change
    create_table :table_predictions do |t|
      t.integer :player_id
      t.integer :team_id
      t.integer :value
      t.integer :points
      t.integer :rebounds
      t.integer :assists
      t.integer :money

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
