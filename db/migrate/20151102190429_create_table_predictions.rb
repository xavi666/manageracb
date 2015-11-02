class CreateTablePredictions < ActiveRecord::Migration
  def change
    create_table :table_predictions do |t|
      t.player_id :integer
      t.team_id :integer
      t.value :integer
      t.points :integer
      t.rebounds :integer
      t.assists :integer
      t.money :integer

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
