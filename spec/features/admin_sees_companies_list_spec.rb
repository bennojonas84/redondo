require "spec_helper"

include FeatureMacros

describe "Admin see company list" do
  subject {page}

  describe "when there are no companies" do
    before {admin_without_company_login}

    it "displays an empty company list" do
      expect(page).to have_link("New Company")
      expect(page).to have_link("View History")
      within("table#companytable") do
        expect(page).to have_selector('thead')
        expect(page).to have_selector('tbody tr', maximum: 0)
      end
        within('table#companytable thead') do
          expect(page).to have_text "LOGO"
          expect(page).to have_text "NAME"
          expect(page).to have_text "USERNAME"
          expect(page).to have_text "ACTION"
        end
    end
  end

  describe "when there are companies" do
    before {admin_with_companies_and_company_user_login}

    it "displays the company list" do
      expect(page).to have_link("View History")
      within("table#companytable") do
        expect(page).to have_selector('thead')
        expect(page).to have_selector('tbody tr', count: 2)
      end
      within("table#companytable tbody") do
        expect(page).to have_text('company_', count: 2)
        expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      end
    end

    it "can see the company detail in a form", js: true do
      visit_company_show_page
      find("form#admin_form").should be_visible
    end

    it "can update the company information", js: true, driver: :poltergeist do
      visit_company_show_page
      find("form#admin_form").should be_visible
      fill_in "company_name", with: "AnotherName"
      fill_in "company_email", with: "email@example.com"
      fill_in "company_password", with: "password"
      find("input[value=Update]").click
      
      expect(Company.where(name: "AnotherName").first).not_to be_nil
    end
  end

  describe "Admin create a company" do
    before { admin_without_company_login }

    it "by clicking on the New Company button", js: true, driver: :poltergeist do
      click_link("New Company")
      # expect(page).to have_text("COMPANY PROFILE")
      fill_in "company_name", with: "My Awesome Company"
      fill_in "company_email", with: "company@skurun.com"
      fill_in "company_url", with: "http://awesomecomp.com"
      fill_in "company_password", with: "password"
      find('input[type=submit][value=Create]').click()

      expect(Company.count).to eq(1)
      # expect(page).to have_text("VIEW COMPANIES")
      within("table#companytable") do
        expect(page).to have_selector('thead')
        expect(page).to have_selector('tbody tr', count: 1)
        expect(page).to have_text("My Awesome Company")
      end
    end
  end

  describe "Admin views History" do
    before { admin_without_company_login }

    it "creates a company and checks the history", js: true do
      click_link("New Company")
      # expect(page).to have_text("COMPANY PROFILE")
      fill_in "company_name", with: "My Awesome Company"
      fill_in "company_email", with: "company@skurun.com"
      fill_in "company_url", with: "http://awesomecomp.com"
      fill_in "company_password", with: "password"
      find('input[type=submit][value=Create]').click()

      click_link("View History")

      # expect(page).to have_text("VIEW HISTORY")
      within("table") do
        expect(page).to have_text("ACTIVE ACTION PASSIVE COMPANY VIEW DATE")
        expect(page).to have_text("#{@admin.email} create My Awesome Company(company@skurun.com) company")
      end
    end

  end

  describe "Admin manages a Company" do
    before { 
      admin_with_companies_and_company_user_login
      @agent = Company.first.agents.first
    }

    it "can access the Agents list for the company" do
      pending()
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      all('a.btn')[1].click()
      expect(page).to have_text("VIEW AGENTS")
      expect(page).to have_title("VIEW AGENTS")
      expect(page).to have_text("#{@agent.email}")
      expect(page).to have_text("#{@agent.first_name}")
      expect(page).to have_text("#{@agent.last_name}")
    end
  end
end