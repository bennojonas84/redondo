class AddCompanyUserToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :company_user, :boolean, :defalut => 0
  end
end
