class AddMaxPriceToUserTeam < ActiveRecord::Migration
  def change
    add_column :user_teams, :max_price_cents, :integer
  end
end
