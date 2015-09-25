require "spec_helper"

include FeatureMacros

describe "Agent see a visit detail page" do
  subject { page }

  before do
    stub_arcgis_request
    agent_with_visit_login
  end

  it "displays the visit details" do    
    visit "/visitdetail?id=#{@agent.visits.first.id}"
    page.should have_selector("a.fancybox")
  end

  it "displays the visit details with visit enthusiasm and quality" do
    visit "/visitdetail?id=#{@agent.visits.first.id}"
    page.should have_text("Enthusiasm: 5")
    page.should have_text("Quality: 5")
  end

  it "displays the visit detail with % ROI lift" do
    visit "/visitdetail?id=#{@agent.visits.first.id}"
    expect(page).to have_text("% ROI Lift: 0%")
  end

  it "and see the demographic datas, retail spending in the visit area", js: true do
    visit "/visitdetail?id=#{@agent.visits.first.id}"
    page.should have_selector('div#retail_spending_table')
    page.should have_text 'Retail Goods : $53,830'
    page.should have_text ' Percent Above or Below U.S Average : 135%'
    page.should have_selector 'div#pop_hh_hi'
    within("div#pop_hh_hi") do
      page.should have_selector('td#total_pop', text: '509')
      page.should have_selector('td#total_hh', text: '293')
    end
  end

  describe "and decides to go back" do
    it "returns to the visits list" do
      
      visit "/visitdetail?id=#{@agent.visits.first.id}"
      # expect(page).to have_content("VIEW VISIT DETAIL")
      within(:css, 'ol.breadcrumb') do
        click_link "Visits"        
      end 
      page.should have_content("VIEW VISITS")
    end
  end
end