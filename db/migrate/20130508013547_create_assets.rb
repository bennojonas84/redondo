class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :filename
      t.string :file_extension
      t.string :description
      t.text :url

      t.timestamps
    end
  end
end
