class AddArchivedColumnToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :archived_status, :boolean, default: false
  end
end
