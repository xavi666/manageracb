class AddTypeFieldToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :type_statistic, :string
  end
end
