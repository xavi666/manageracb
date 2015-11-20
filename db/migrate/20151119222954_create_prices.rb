class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :price_cents
      t.integer :player_id
      t.integer :game_number
      t.string :season

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
