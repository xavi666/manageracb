class AddShortCodeToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :short_code, :string    
  end
end
