class CreateTablePlayer < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.string :name
      t.integer :age
      t.date :date_of_birth
      t.integer :team_id



      t.boolean :active, default: true
      t.timestamps
    end
  end

  def down
    drop_table :players
  end
end
