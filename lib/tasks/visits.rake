namespace :visits do
  desc "Update the existing visits for reporting purpose"
  task update: :environment do
    Visit.all.each do |visit|
      visit.asset_id_array = [] if visit.asset_id_array.nil?
      visit.save if visit.creation_time.nil? || visit.asset_id_array.empty? || visit.retailer_id.nil? || visit.retailer_id.blank?
    end
  end

  desc "Correct the value of visit_enthusiasm and visit_quality from 'n/a' to 0"
  task correct: :environment do
    Visit.where(visit_enthusiasm: 'n/a').update_all(visit_enthusiasm: '0')
    Visit.where(visit_quality: 'n/a').update_all(visit_quality: '0')
  end
end