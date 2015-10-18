class CreateTablePlayer < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.date :date_of_birth
      t.integer :team_id
      t.integer :number
      t.integer :position
      t.string :nationality

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
