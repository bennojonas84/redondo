namespace :assets do
  desc "Update the existing assets for db queries optimization purpose"
  task update: :environment do
    Asset.all.each do |asset|
      asset.save
    end
  end
end