require "spec_helper"

describe "Admin gets visits report" do
  
  subject { page }

  describe "admin get visits report for a company" do
    before do
      admin_with_companies_and_company_user_login
      @company = Company.first
    end

    it "with an 'Excel report' link", js: true do
      expect(page).to have_selector('a.btn', text: 'Manage', count: 2)
      all('td.show-company-form')[0].click()

      expect(page).to have_selector('a.visits_report')
    end

    it "downloads an excel file", js:true do
      all('td.show-company-form')[0].click()
      click_link('Excel Report')

      expect(page.response_headers['Content-Transfer-Encoding']).to eq('binary')
      expect(page.response_headers['Content-Type']).to eq('application/vnd.ms-excel')
      expect(page.response_headers['Content-Disposition']).to eq('attachment')
      expect(page.source.length).to be > 0
    end
  end
end