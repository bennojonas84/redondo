class AddIsdeveloperColumnToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :is_developer, :boolean, default: false
  end
end
