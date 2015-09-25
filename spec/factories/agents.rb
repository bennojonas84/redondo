FactoryGirl.define do
  sequence(:email) { |n| "person_#{n}@example.com"}   
  sequence(:first_name) { |n| "John_#{n}"}
  sequence(:last_name) {|n| "Doe_#{n}"}

  factory :agent do
    first_name { generate(:first_name) }
    last_name { generate(:last_name) }
    email { generate(:email) }
    password "please"
    password_confirmation "please"
    asadmin false
    company_user false
    photo_url nil

    company

    factory :agent_with_attachment do
      photo { File.new(Rails.root + 'spec/fixtures/sample.jpg')}
    end

    factory :admin_agent do
      asadmin true
    end

    factory :company_agent do
      company_user true
    end

    factory :admin_company_agent do
      asadmin true
      company_user true
    end

    factory :agent_with_visits do
      ignore do
        visits_count 2
      end
      after(:create) do |agent, evaluator|
        FactoryGirl.create_list(:visit, evaluator.visits_count, agent: agent)
      end
    end
  end  
end