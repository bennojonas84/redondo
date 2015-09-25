class AddPhotoUrlToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :photo_url, :text
  end
end
