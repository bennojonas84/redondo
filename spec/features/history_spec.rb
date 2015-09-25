require "spec_helper"

include FeatureMacros

describe "History" do
  subject {page}
  
  # describe "for asset creation" do
  #   context "when admin agent (ORG Admin) is logged-in" do
  #     before do 
  #       stub_paperclip_s3('Asset', 'image', 'png')
  #       admin_company_agent_login
  #       @company = @agent.company
  #     end

  #     it "records asset creation", js: true do
  #       expect(page).to have_content('ASSETS')
  #       within(:css, "div#tab") do
  #         find("a[href='/assets?id=#{@company.id}']").click()
  #       end

  #       click_link "New Asset"
  #       find("input#asset_description")
  #       fill_in "asset_description", with: "asset from agent"
  #       # fill_in "imagepath", with: "http://sample.com/pic/123"
  #       # attach_file('asset_image', File.join('spec', 'fixtures', 'sample.png'))
  #       click_button "Create"

  #       expect(Asset.count).to eq(1)
  #       expect(History.count).not_to eq(0)

  #       event = History.first
  #       expect(event.company_name).to eq(@company.name)
  #       expect(event.active_name).to eq(@agent.email)
  #       expect(event.passive_name).to eq(Asset.first.image_file_name)
  #       expect(event.action).to eq("create")
  #       expect(event.sort).to eq("asset")
  #     end
  #   end

  #   context "when added by an admin" do
  #     before do
  #       Asset.delete_all
  #       History.delete_all
  #       stub_paperclip_s3('Asset', 'image', 'png')
  #       admin_with_companies_and_company_user_login
  #       @company = Company.last
  #       @company_agent = @company.agents.first
  #     end

  #     it "doesn't record Asset creation", js: true do
  #       expect(page).to have_selector('a.btn', text: "Manage", count: 2)
  #       find("a.btn[href='/rm/SkuRun/companies/manage?superagent_id=#{@company_agent.id}']").click()

  #       find("a.tab[href='/assets?id=#{@company.id}']").click()

  #       click_link "New Asset"
  #       find("input#asset_description")
  #       fill_in "asset_description", with: "asset from agent"
  #       # fill_in "imagepath", with: "http://sample.com/pic/123"
  #       # attach_file('asset_image', File.join('spec', 'fixtures', 'sample.png'))
  #       click_button "Create"

  #       expect(Asset.count).to eq(1)
  #       # expect(History.count).to eq(0)
  #       # puts History.first.inspect if History.count > 0
  #     end
  #   end
  # end
end