class AddConfirmableToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :confirmation_token, :string
    add_column :agents, :confirmed_at, :datetime
    add_column :agents, :confirmation_sent_at, :datetime
    add_column :agents, :unconfirmed_email, :string
    
    add_index :agents, :confirmation_token, :unique => true
  end
  
  def self.down
    remove_index :agents, :confirmation_token
    
    remove_column :agents, :unconfirmed_email
    remove_column :agents, :confirmation_sent_at
    remove_column :agents, :confirmed_at
    remove_column :users, :confirmation_token
  end
end
