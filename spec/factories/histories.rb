FactoryGirl.define do
  factory :history do
    company_name "A company name"
    active_name "an active name"
    passive_name "a passive name"
    action "action description"
    action_date 1.week.ago
  end
end