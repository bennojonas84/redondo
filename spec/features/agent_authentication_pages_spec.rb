require "spec_helper"

describe "Agent Authentication" do

  subject { page }

  describe "signin page" do
    before { visit new_agent_session_path }

    it { should have_selector('div#companyprofile p', text: 'agent SIGN IN') }
    it { should have_selector('input[name=commit]') }
  end

  describe "signin" do
    before { 
      @agent = FactoryGirl.create(:agent)
      @agent.confirm!
      visit new_agent_session_path
    }

    describe "with invalid information" do
      it "fails" do
        fill_in "agent_email", with: 'bademail@example.com'
        fill_in 'agent_password', with: 'badpassword'
        all("input[type=submit]")[0].click

        expect(page).to have_selector('div.alert.alert-alert', text: 'Invalid email or password.')
        expect(page).to have_selector('div#companyprofile p', text: 'agent SIGN IN')
      end 
    end

    describe "with valid information" do
      it "succeeds and shows the agent visits list page" do
        fill_in 'agent_email', with: @agent.email
        fill_in 'agent_password', with: 'please'
        all("input[type=submit]")[0].click
        
        # expect(page).to have_selector('div.navbar-inner span', text: 'VIEW VISITS')
        # expect(page).to have_selector('input[type=submit][value=Logout]')
        expect(page).to have_content("PREVIEW TITLE IMAGES AGENT CREATED AT")
      end
    end
  end  

end