class AddJsonParsedColumnsToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :title, :string
    add_column :visits, :agent_name, :string
    add_column :visits, :image_count, :integer
    add_column :visits, :city, :string
    add_column :visits, :location, :string
    add_column :visits, :zipcode, :string
    add_column :visits, :street, :string
    add_column :visits, :state, :string
    add_column :visits, :latitude, :string
    add_column :visits, :longitude, :string
    add_column :visits, :phone_number, :string
    add_column :visits, :url, :string
    add_column :visits, :comment, :string
    add_column :visits, :visit_enthusiasm, :string
    add_column :visits, :visit_quality, :string
    add_column :visits, :visit_type, :string
    add_column :visits, :creation_time, :datetime
    add_column :visits, :address, :string
  end
end
