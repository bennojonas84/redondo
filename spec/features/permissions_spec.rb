require "spec_helper"
require "cancan/matchers"

describe "Developer permissions" do

  subject(:ability) { Ability.new(user) }
  let(:user) { FactoryGirl.create(:developer_admin) }

  it { should be_able_to(:manage, Company.new) }
  it { should be_able_to(:manage, Asset.new) }
  it { should be_able_to(:manage, Agent.new) }
  it { should be_able_to(:manage, Visit.new) }
  it { should be_able_to(:manage, Report) }

end

describe "UberAdmin permissions" do
  
  subject(:ability) { Ability.new(user) }
  let(:user) { FactoryGirl.create(:uber_admin) }

  it { should_not be_able_to(:manage, Company) }
  it { should be_able_to(:manage, Asset) }
  it { should be_able_to(:manage, Agent) }
  it { should_not be_able_to(:manage, Visit) }
  it { should be_able_to(:read, Visit) }
  it { should be_able_to(:manage, Report) }

end

describe "Company Admin permissions" do
  
  let(:other_company) { FactoryGirl.create(:company_with_agents_and_visits) }
  let(:admin_company) { FactoryGirl.create(:company_with_agents_and_visits) }
  let(:company_admin) { FactoryGirl.create(:admin_company_agent, company_id: admin_company.id) }
  let(:other_company_asset) { FactoryGirl.create(:asset, company: other_company) }
  let(:company_asset) { FactoryGirl.create(:asset, company: admin_company) }

  subject(:ability) { Ability.new(company_admin) }

  it { should_not be_able_to(:manage, admin_company) }
  it { should_not be_able_to(:manage, other_company) }
  it { should_not be_able_to(:manage, other_company_asset) }
  it { should_not be_able_to(:manage, other_company.agents.first) }
  it { should be_able_to(:manage, company_asset) }
  it { should be_able_to(:manage, admin_company.agents.first) }
  it { should be_able_to(:manage, Report) }

end

describe "Company Agent permissions" do

  let(:other_company) { FactoryGirl.create(:company_with_agents_and_visits) }
  let(:agent) { FactoryGirl.create(:agent_with_visits) }
  let(:visit) { agent.visits.first }
  let(:other_company_visit) { other_company.visits.first }
  subject(:ability) { Ability.new(agent) }

  it { should be_able_to(:read, visit) }
  it { should_not be_able_to(:read, other_company_visit) }
  
end