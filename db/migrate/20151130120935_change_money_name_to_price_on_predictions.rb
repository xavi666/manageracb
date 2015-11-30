class ChangeMoneyNameToPriceOnPredictions < ActiveRecord::Migration
  def change
    rename_column :predictions, :money, :price_cents
  end
end
