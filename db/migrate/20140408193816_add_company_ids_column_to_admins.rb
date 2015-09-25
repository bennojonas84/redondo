class AddCompanyIdsColumnToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :company_ids, :integer, array: true, default: []
  end
end
