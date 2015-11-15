class CreateTableSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.string :value

      t.boolean :active, default: true
      t.timestamps
    end

    setting = Setting.new
    setting.name = "season_data"
    setting.value = "2014"
    setting.save!

    setting = Setting.new
    setting.name = "season"
    setting.value = "2015"
    setting.save!

    setting = Setting.new
    setting.name = "game_number"
    setting.value = 5
    setting.save!

  end
end
