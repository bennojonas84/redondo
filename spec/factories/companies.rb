FactoryGirl.define do
  
  sequence(:company_name) { |n| "company_#{n}" }
  sequence(:company_url) { |n| "http://www.company#{n}.com" }

  factory :company do
    name { generate(:company_name) }
    url { generate(:company_url) }
    # logo { File.new(Rails.root + 'spec/fixtures/sample.jpg') }

    factory :company_with_agent do
      after(:create) do |company|
        agent = FactoryGirl.create(:agent, company: company, company_user: true, asadmin: true)
        agent.confirm!
      end
    end

    factory :company_with_agents_and_visits do
      after(:create) do |company|
        agent = FactoryGirl.create(:agent_with_visits, company: company, company_user: true, asadmin: true)
        agent.confirm!
      end
    end

    factory :company_with_agents_and_visits_on_2_years do
      after(:create) do |company|
        agent = FactoryGirl.create(:agent, company: company, company_user: true ,asadmin: true)
        2.times do |i|
          visit = FactoryGirl.create(:json_simplified_visit_yearly, agent: agent, body: { archived?: 0, created_at: (Time.now - (i).year).to_i, visit_name: Faker::Company.name, visit_type: VISIT_TYPES[rand(VISIT_TYPES.length)], assets: [], retailer_info: {name: "retailer_name_#{i}", zip: "95014" }}.to_json, zipcode: 95014)       
        end
      end
    end

    factory :company_for_report_testing do
      after(:create) do |company|
        agent_smith = FactoryGirl.create(:agent, company: company, company_user:true, asadmin: true)
        agent_neo = FactoryGirl.create(:agent, company: company)
        agent_morpheus = FactoryGirl.create(:agent, company: company)
        FactoryGirl.create_list(:json_simplified_visit_noAssets, 5, agent: agent_smith)
        FactoryGirl.create_list(:json_simplified_visit_noAssets, 10, agent: agent_neo)
        FactoryGirl.create_list(:json_simplified_visit_noAssets, 15, agent: agent_morpheus)
      end
    end

    factory :company_for_report_testing2 do
      after(:create) do |company|
        agent_smith = FactoryGirl.create(:agent, company: company, company_user:true, asadmin: true)
        agent_neo = FactoryGirl.create(:agent, company: company)
        agent_morpheus = FactoryGirl.create(:agent, company: company)
        3.times { FactoryGirl.create(:json_simplified_visit_noAssets2, agent: agent_smith) }
        5.times { FactoryGirl.create(:json_simplified_visit_noAssets2, agent: agent_neo) }
        10.times { FactoryGirl.create(:json_simplified_visit_noAssets2, agent: agent_morpheus) }
      end
    end
  end
end