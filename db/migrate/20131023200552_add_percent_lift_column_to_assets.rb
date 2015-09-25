class AddPercentLiftColumnToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :percent_lift, :integer
  end
end
