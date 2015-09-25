class AddAssetUrlIdColumnToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :asset_url_id, :integer
  end
end
