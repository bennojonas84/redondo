class AddLogoColumnsToCompanies < ActiveRecord::Migration
  def change
    add_attachment :companies, :logo
  end
end
