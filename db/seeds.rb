# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "EMPTYING database"
Company.delete_all
Agent.delete_all
Visit.delete_all
Asset.delete_all
Admin.delete_all

puts 'CREATE A COMPANY'
company = Company.create(name: 'SkuRun', url: 'http://skurun.com')

puts 'CREATE AN COMPANY AGENT'
agent = Agent.create(first_name: 'Demo',
                     last_name: 'SkuRun',
                     email: 'demo1@skurun.com',
                     password: 'please',
                     password_confirmation: 'please',
                     company_id: company.id)
agent.confirm!

puts 'CREATE Admin agent aka Company Admin'
superagent = Agent.create(first_name: 'John',
                          last_name: 'SkuRun',
                          email: 'superagent@skurun.com',
                          password: 'please',
                          password_confirmation: 'please',
                          asadmin: 1,
                          company_user:true,
                          company_id: company.id)
superagent.confirm!

puts 'CREATE ADMIN'
admin = Admin.create(email: 'admin@skurun.com',
                     password: 'please',
                     password_confirmation: 'please',
                     is_developer: true)

puts 'CREATE UBER ADMIN'
uber_admin = Admin.create(email: 'uberadmin@skurun.com',
                          password: 'please',
                          password_confirmation:'please',
                          is_developer: false)

puts 'CREATE VISIT FOR AGENT'
visit = FactoryGirl.create(:visit, agent: agent)

puts 'CREATE 4 ASSETS'
asset_url_ids = [1369253809, 1373045015, 1370368869, 1370368848]
asset_url_ids.each do |url_id|
  begin
    asset = Asset.new(description: 'random',
                 url: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQjYJZRKfafZ09zcVFQXH3wW_kA_1JgLCZvJJ2kxcXI8q4Ecvjj',
                 company_id: company.id)
    file = File.open(File.join("#{Rails.root}", "spec", "support", "paperclip","asset", "image-#{url_id}.png"))
    asset.image = file
    file.close
    asset.save!
    original_url_number = asset.url.match(/\d+$/)[0]
    new_url = asset.url.gsub(original_url_number, url_id.to_s)
    asset.update_columns({url: asset.url.gsub(original_url_number, url_id.to_s), asset_url_id: url_id})
  rescue Exception => e
    puts e.inspect
    puts e.message
  end
end

puts 'CREATE DEMO STATE JURIDICTION'
puts 'creating demo company'
demo_company = Company.create(name: 'DemoInc', url: 'http://skurun.com')

puts 'creating demo agent'
demo_agent = Agent.create(first_name: 'Demo', last_name: 'Skurun', email: 'demo@skurun.com', password: 'redondo', password_confirmation: 'redondo', company_id: demo_company.id)
demo_agent.confirm!

puts 'creating fake visits for demo agent'
# visits = FactoryGirl.create_list(:visit_with_several_assets, 5, agent: demo_agent)
Asset.count.times do |i|
  asset = Asset.all[i]
  visit = FactoryGirl.create(:visit, agent_id: demo_agent.id)
  visit.asset_id_array_will_change!
  visit.asset_id_array.push(asset.asset_url_id)
  visit.save
end
