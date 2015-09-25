class AddPhotoColumnsToAgents < ActiveRecord::Migration
  def change
    add_attachment :agents, :photo
  end
end
