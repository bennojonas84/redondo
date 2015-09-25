class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :first_name
      t.string :last_name
      t.string :photo
      t.integer :company_id
      
      t.timestamps
    end
  end
end
