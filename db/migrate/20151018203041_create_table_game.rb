class CreateTableGame < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :local_team_id
      t.integer :visitant_team_id
      t.integer :local_score
      t.integer :visitant_score
      t.datetime :date_time
      t.string :place
      t.string :referees  
      t.string :p1
      t.string :p2
      t.string :p3
      t.string :p4

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
