class AddImageColumnsToAssets < ActiveRecord::Migration
  def change
    add_attachment :assets, :image
  end
end
