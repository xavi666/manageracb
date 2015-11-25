class AddReceivedColumnsToStatistic < ActiveRecord::Migration
  def change
    add_column :statistics, :value_received, :integer
    add_column :statistics, :points_received, :integer
    add_column :statistics, :assists_received, :integer
    add_column :statistics, :rebounds_received, :integer
    add_column :statistics, :three_pm_received, :integer
  end
end
