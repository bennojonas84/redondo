class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :company_name
      t.string :active_name
      t.string :passive_name
      t.string :action
      t.timestamp :action_date

      t.timestamps
    end
  end
end
