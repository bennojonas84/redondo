FactoryGirl.define do
  factory :admin do    
    email { generate(:email) }
    password "password"
    password_confirmation "password"

    factory :admin_with_companies do
      ignore do
        companies_count 2
      end
      after(:create) do |admin, evaluator|
        FactoryGirl.create_list(:company, evaluator.companies_count)
      end
    end

    factory :admin_with_companies_with_company_user do
      ignore do
        companies_count 2
      end
      after(:create) do |admin, evaluator|
        FactoryGirl.create_list(:company_with_agent, evaluator.companies_count)
      end
    end

    factory :developer_admin do
      is_developer true
    end

    factory :uber_admin do
      is_developer false
    end
  end
end