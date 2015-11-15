class AddSeasonToHtmlPage < ActiveRecord::Migration
  def change
    add_column :html_pages, :season, :string
  end
end
