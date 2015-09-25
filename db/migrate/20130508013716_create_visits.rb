class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :name
      t.text :body
      t.integer :agent_id

      t.timestamps
    end
  end
end
