class CreateTableSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.string :value

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
