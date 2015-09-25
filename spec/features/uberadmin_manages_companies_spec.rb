require "spec_helper"

describe "Companies management policy" do

  subject { page }

  describe "Developer Admin selects which uber_admin manages which companies" do
    let(:uber_admin) { FactoryGirl.create(:uber_admin) }
    let(:uber_admin2) { FactoryGirl.create(:uber_admin) }

    before do
      @company = FactoryGirl.create(:company_with_agents_and_visits)
      developer_admin_login
    end

    it "by visiting company show page", js: true do
      visit_company_show_page
      click_link('Uber Admin')
      expect(page).to have_selector("#assigned_uber_admin")
      expect(page).to have_selector("#all_uber_admins")
    end

    after do
      developer_admin_logout
    end
  end
end

describe "A company can be manage by only one Uber Admin" do
  
end