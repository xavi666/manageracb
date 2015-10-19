class CreateHtmlPages < ActiveRecord::Migration
  def change
    create_table :html_pages do |t|
      t.integer :game_number
      t.integer :code
      t.text :html  

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
