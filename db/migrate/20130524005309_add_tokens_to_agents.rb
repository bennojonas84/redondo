class AddTokensToAgents < ActiveRecord::Migration
  def change
    change_table :agents do |t|
      t.string :authentication_token
    end
    add_index  :agents, :authentication_token, :unique => true
  end
end
