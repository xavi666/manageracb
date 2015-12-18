class AddSecondNameToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :second_name, :string
  end
end
