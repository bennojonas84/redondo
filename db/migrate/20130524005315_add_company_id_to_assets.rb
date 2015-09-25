class AddCompanyIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :company_id, :integer
  end
end
