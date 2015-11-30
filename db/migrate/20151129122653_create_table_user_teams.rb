class CreateTableUserTeams < ActiveRecord::Migration
  def change
    create_table :user_teams do |t|
      t.string :name

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
