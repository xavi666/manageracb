class AddHtmlPageTypeToHtmlPage < ActiveRecord::Migration
  def change
    add_column :html_pages, :html_page_type, :string
  end
end
