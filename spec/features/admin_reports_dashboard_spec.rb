require "spec_helper"

describe "Report Dashboard" do
  subject { page }

  describe "admin access to reports Dashboard" do
    before do
      # admin_with_companies_and_company_user_with_visits_login
      @company = Company.first
    end

    it "through the Report Menu under Agents/Visits/Assets" do
      pending
      expect(page).to have_selector('')
    end
  end
end