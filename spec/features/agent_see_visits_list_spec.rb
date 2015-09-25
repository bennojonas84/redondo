require "spec_helper"

include FeatureMacros

describe "Agent see his visits list" do

  subject { page }

  describe "when he has 0 visits" do
    before { no_visit_agent_login }

    it "displays an empty visit list" do
      expect(page).to have_content('VIEW VISITS')
      expect(page).to have_selector("form#visits_search")
      expect(page).to have_selector('tr', text: "ID")
      expect(page).to have_selector('tr', text: "PREVIEW")
      expect(page).to have_selector('tr', text: "TITLE")
      expect(page).to have_selector('tr', text: "IMAGE")        
      expect(page).to have_selector('tr', text: "AGENT")        
      expect(page).to have_selector('tr', text: "CREATED AT")
    end
  end

  describe "when he has got some visits" do
    before { agent_with_visit_login }

    it "display the agent's visits" do
      # expect(page).to have_selector('form#visits_search label', text: "Total: 2")
      expect(page).to have_selector('form#visits_search table tbody tr', maximum: 2)
      expect(page).to have_text("Wood Spoon", maximum: 2)
      expect(page).to have_text("Retail Makeover", maximum: 2)
      expect(page).to have_text("Wed, 29 May 13 14:23:54 United States Time (Los Angeles)", maximum: 2)
    end

    it "can access to 2 tabs : Visits list and Map" do
      expect(page).to have_selector("nav#tabs>ul#visitsTab>li>a[href='#visits_list']") 
      expect(page).to have_selector("nav#tabs>ul#visitsTab>li>a[href='#visits_map']")
    end

    it "he can see the visits on a Map" do
      pending()
      click('visits-tab-map')
      expect(page).to have_selector()
    end
  end

end