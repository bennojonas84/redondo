class AddRetailerIdColumnsToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :retailer_id, :string
  end
end
