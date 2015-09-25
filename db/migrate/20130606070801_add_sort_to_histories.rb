class AddSortToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :sort, :string
  end
end
