class CreateUserTeamPlayers < ActiveRecord::Migration
  def change
    create_table :user_team_players do |t|
      t.references :user_team, index: true
      t.references :player, index: true

      t.timestamps null: false
    end
  end
end
