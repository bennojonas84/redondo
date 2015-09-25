class AddAsadminToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :asadmin, :integer
  end
end
