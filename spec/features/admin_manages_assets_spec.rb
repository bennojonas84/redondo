require "spec_helper"

describe "Admin manages Asset" do
  subject {page}

  describe "Admin creates asset" do
    before do
      stub_paperclip_s3("asset", "image", "png")
      admin_with_companies_and_company_user_login
      @company = Company.first
      @company_agent = @company.agents.first
    end

    it "by choosing a company to manage, clicking on the Side menu Assets link and the Add Asset button", js:true, driver: :poltergeist do
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      find("a.btn[href='/rm/SkuRun/companies/manage?superagent_id=#{@company_agent.id}']").click()
      
      find("a.tab[href='/assets?id=#{@company.id}']").click()
      click_link("New Asset")
      
      find("input#asset_description")
      fill_in "asset_description", with: "asset from agent"
      # fill_in "imagepath", with: "http://sample.com/pic/123"
      # attach_file('asset_photo', File.join('spec', 'fixtures', 'sample.png'))
      page.execute_script("$('#percent_lift_slider').val('55');")
      page.execute_script("$('#asset_percent_lift').val('55');")
      click_button "Create"

      expect(Asset.count).to eq(1)
      expect(Asset.first.percent_lift).to eq(55)
      expect(page).to have_text "asset from agent"
    end
  end

  describe "Admin updates asset" do
    before do
      stub_get_paperclip_s3("asset", "image", "png")
      admin_with_companies_and_company_user_login
      @company = Company.first
      @company_agent = @company.agents.first
    end

    it "by clicking on the asset and using the form", :js => true do
      pending
      expect(page).to have_selector('table a.btn', text: "Manage", count: 2)
      all('table a.btn')[0].click()
      within(:css, "div#tab") do
        find("a[href='/assets?id=#{@company.id}']").click()
      end
      click_link("Add Asset")

      fill_in "asset_description", with: "asset from agent"
      # fill_in "imagepath", with: "http://sample.com/pic/123"
      page.execute_script("$('#percent_lift_slider').val('55');")
      page.execute_script("$('#asset_percent_lift').val('55');")
      attach_file('asset_image', File.join('spec', 'fixtures', 'sample.png'))
      click_button "Create"
      
      expect(Asset.count).to eq(1)
      expect(page).to have_text "asset from agent"

      # all('tr.show-asset-form').last.click()
      find('html body div.container div.row div.span5 table.fix-table').click()
      find("form#edit_asset_#{Asset.first.id}").should be_visible
      # udpate asset informations
      fill_in 'asset_description', with: 'asset from superagent'
      page.execute_script("$('#asset_percent_lift').val('75');")
      find("input[value='Update']").click()
      expect(Asset.first.description).to eq("asset from superagent")
      expect(Asset.first.percent_lift).to eq(75)
    end
  end

  describe "Admin deletes asset" do
    before do
      stub_paperclip_s3("asset", "image", "png")
      admin_with_companies_and_company_user_login
      @company = Company.first
      @company_agent = @company.agents.first
    end

    it "by clicking on the asset and using the form", :js => true do
      pending
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      all('table a.btn')[0].click()
    
      within(:css, "div#tab") do
        find("a[href='/assets?id=#{@company.id}']").click()
      end
      click_link("Add Asset")

      fill_in "asset_description", with: "asset from agent"
      fill_in "imagepath", with: "http://sample.com/pic/123"
      attach_file('asset_image', File.join('spec', 'fixtures', 'sample.png'))
      click_button "Create"

      expect(Asset.count).to eq(1)
      expect(page).to have_text "asset from agent"

      find('html body div.container div.row div.span5 table.fix-table').click()
      page.find("form#edit_asset_#{Asset.first.id}").should be_visible
      # delete the asset
      click_link "Delete"

      expect(page).not_to have_text "asset from agent"
      expect(Asset.count).to eq(1)
    end
  end
end