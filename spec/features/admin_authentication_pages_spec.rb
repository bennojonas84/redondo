require 'spec_helper'

describe "Admin Authentication" do
  
  subject { page }
  
  describe "signin page" do
    before { visit new_admin_session_path }
    
    it { should have_selector('div#userprofile>p.uppercase', text: 'admin SIGN IN')}
    it { should_not have_link('Sign up',  href: new_admin_registration_path) }
       
  end
  
  describe "signin" do
    before { 
      @admin = FactoryGirl.create(:admin)
      visit new_admin_session_path
    }
    
    describe "with invalid information" do
      before { find("input[type='submit']").click }
      
      it { should have_selector('div#userprofile>p.uppercase', text: 'admin SIGN IN') }
      it { should have_selector('div.alert.alert-alert', text: 'Invalid email or password.') }
      
    end

    describe "with valid information" do
      it "works" do
        fill_in 'admin_email', with: @admin.email
        fill_in 'admin_password', with: 'password'
        all("input[type=submit]")[0].click

        expect(page).to have_link('Logout')
        expect(page).to have_selector('div.alert.alert-notice', text: 'Signed in successfully.')
      end

    end
                 
  end
end