require "spec_helper"

describe "Admin signs up" do
  subject { page }

  describe "admin sign_up page is not publicly accessible" do
    before { visit destroy_admin_session_path }

    it "can't access /rm/SkuRun/sign_up" do
      true
    end

    it "can't acces /rm/SkurRun/registrations/new" do
      visit "/rm/SkuRun/registrations/new"
      expect(page).to have_selector('div#userprofile p.uppercase', text: 'admin SIGN IN')
    end
  end

  describe "Signed-in admin can register another admin" do
    before { admin_without_company_login }

    it "through the admin registration form successfully" do
      click_link "New Uber-Admin"
      expect(page).to have_selector("div#companyprofile p", text: 'ADMIN SIGNUP')
      expect(page).to have_selector("input#admin_email")
      expect(page).to have_selector("input#admin_password")
      expect(page).to have_selector("input#admin_password_confirmation")

      fill_in "admin_email", with: "admin2@skurun.com"
      fill_in "admin_password", with: "please"
      fill_in "admin_password_confirmation", with: "please"
      find('input[value="Sign up"]').click()

      expect(Admin.count).to eq(2)
      expect(page).to have_text('New Admin successfully created!')
    end

    it "through the admin registration form unsuccessfully" do
      click_link "New Uber-Admin"
      expect(page).to have_selector("div#companyprofile p", text: 'ADMIN SIGNUP')
      expect(page).to have_selector("input#admin_email")
      expect(page).to have_selector("input#admin_password")
      expect(page).to have_selector("input#admin_password_confirmation")

      fill_in "admin_email", with: @admin.email
      fill_in "admin_password", with: "please"
      fill_in "admin_password_confirmation", with: "please"
      find('input[value="Sign up"]').click()

      expect(page).to have_text('Email has already been taken')
    end
  end
end