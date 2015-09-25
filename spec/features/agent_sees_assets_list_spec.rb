require "spec_helper"

include FeatureMacros
include S3RequestStub

describe "Agent consult Assets" do
  subject { page }

  describe "when he has got 0 assets" do
    describe "and he is not a company_user" do
      before do
        agent_without_assets_login
        @company = @agent.company
      end
      
      it "doesn't access to the assets page" do
        expect(page).not_to have_selector("a[href='/assets?id=#{@company.id}']")
        expect(page).to have_content("VIEW VISITS")
      end
    end

    describe "and he is a company_user" do
      before do
        @agent = FactoryGirl.create(:company_agent)
        @company = @agent.company
        login_with_agent(@agent)
      end

      it "can access the assets index page" do
        within(:css, 'div#tab') do
          find("a[href='/assets?id=#{@company.id}']").click()
        end
        expect(page).to have_content("VIEW ASSETS")
        expect(page).to have_link("New Asset")
        expect(page).not_to have_text("a shop looking like a river")
      end
    end
  end

  describe "when he has got some assets" do
    describe "but he isn't a company admin" do
      before do
        stub_paperclip_s3("asset", "image", "png")
        @asset = FactoryGirl.create(:asset)
        @company = @asset.company
        @agent = FactoryGirl.create(:agent, company: @company)
        login_with_agent(@agent)
      end
      
      it "doesn't access to the assets page" do
        within(:css, "div#tab") do
          expect(page).not_to have_selector("a[href='/assets?id=#{@company.id}']")
        end
        expect(page).to have_content("VIEW VISITS")
        expect(page).not_to have_text("a shop looking like a river")
      end
    end

    describe "and he is a company admin" do
      before do
        stub_paperclip_s3("asset", "image", "png")
        @asset = FactoryGirl.create(:asset)
        @company = @asset.company
        @agent = FactoryGirl.create(:company_agent, company: @company)
        login_with_agent(@agent)
      end

      it "can access the assets index page" do
        within(:css, 'div#tab') do
          find("a[href='/assets?id=#{@company.id}']").click()
        end
        expect(page).to have_content("VIEW ASSETS")
        expect(page).to have_link("New Asset")
        expect(page).to have_text("a shop looking like a river")
      end
    end

    describe "which are associated with some visits, while being a company admin," do
      before(:each) do
        set_up_complete_dataset_similar_to_seed
        login_with_agent(@superagent)
      end

      it "can see the associated visit count" do
        within(:css, 'div#tab') do
          find("a[href='/assets?id=#{@company.id}']").click()
        end
        expect(page).to have_content('VISITS 4')
      end

      it "can see the associated visits list" do
        within(:css, 'div#tab') do
          find("a[href='/assets?id=#{@company.id}']").click()
        end
        expect(page).to have_content('VISITS 4')

        all('a', text: 'VISITS 4')[0].click()
        expect(page).to have_content('VIEW ASSET VISITS')
        expect(page).to have_content('Total: 4')
        expect(page).to have_content("#{@agent.visits.last.title}")
      end

      after(:each) do
        tear_down_complete_dataset
      end
    end
  end
end