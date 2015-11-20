class AddImageToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :image, :string
    add_column :players, :nacionality, :string
    add_column :players, :price_cents, :integer
  end
end
