module FeatureMacros
  def login
    visit new_agent_session_path
    fill_in "agent_email", with: @agent.email
    fill_in "agent_password", with: 'please'
    all("input[type=submit]")[0].click
  end


  def agent_logout
    visit destroy_agent_session_path
  end

  def no_visit_agent_login
    @agent = FactoryGirl.create(:agent)
    @agent.confirm!
    login
  end

  def agent_with_visit_login
    @agent = FactoryGirl.create(:agent_with_visits)
    @agent.confirm!
    login
  end

  def agent_without_assets_login
    no_visit_agent_login
  end

  def login_with_agent(agent)
    agent.confirm!
    visit new_agent_session_path
    fill_in "agent_email", with: agent.email
    fill_in "agent_password", with: 'please'
    all("input[type=submit]")[0].click
  end

  def company_agent_login
    @agent = FactoryGirl.create(:company_agent)
    @agent.confirm!
    login
  end

  def admin_company_agent_login
    @agent = FactoryGirl.create(:admin_company_agent)
    @agent.confirm!
    login
  end

  def admin_login
    visit '/rm/SkuRun/sign_in'
    # visit new_admin_session_path
    fill_in "admin_email", with: @admin.email
    fill_in "admin_password", with: "password"
    all("input[type=submit]")[0].click
  end

  def admin_without_company_login
    @admin = FactoryGirl.create(:developer_admin)
    admin_login
  end

  def admin_with_companies_login
    @admin = FactoryGirl.create(:admin_with_companies)
    admin_login
  end

  def admin_with_companies_and_company_user_login
    @admin = FactoryGirl.create(:admin_with_companies_with_company_user)
    admin_login
  end

  def developer_admin_login
    @admin = FactoryGirl.create(:developer_admin)
    admin_login
  end

  def developer_admin_logout
    visit destroy_admin_session_path
  end

  def agent_views_a_visit_detail_page
    stub_arcgis_request
    agent_with_visit_login
    visit "/visitdetail?id=#{@agent.visits.first.id}"
    agent_logout
  end

  def agent_views_a_visit_and_download_images
    stub_arcgis_request
    agent_with_visit_login
    visit "/visitdetail?id=#{@agent.visits.first.id}"
    click_link("Export")
    click_link("download_all")
    agent_logout
  end

  def show_html
    save_and_open_page
  end

  def visit_company_show_page
    page.should have_selector('td.show-company-form')
    all('td.show-company-form')[0].click()
    within("ul#companyTabs") do
      page.should have_selector("li>a[href='#company_detail'][data-toggle=tab]")
      page.should have_selector("li>a[href='#company_uber_admin'][data-toggle=tab]")
    end
  end

  def set_up_complete_dataset_similar_to_seed
    @company = FactoryGirl.create(:company)
    @agent = FactoryGirl.create(:agent, company_id: @company.id)
    @superagent = FactoryGirl.create(:admin_company_agent, company_id: @company.id)
    @admin = FactoryGirl.create(:developer_admin)
    @uber_admin = FactoryGirl.create(:uber_admin)
    build_associated_assets_visits(@company, @agent)
  end

  def build_associated_assets_visits(company, agent)
    asset_url_ids = [1369253809, 1373045015, 1370368869, 1370368848]
    asset_url_ids.each do |url_id|
      stub_paperclip_s3("asset", "image", "png")
      asset = Asset.new(description: 'random',
                   url: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQjYJZRKfafZ09zcVFQXH3wW_kA_1JgLCZvJJ2kxcXI8q4Ecvjj',
                   company_id: company.id)
      file = File.open(File.join("#{Rails.root}", "spec", "support", "paperclip","asset", "image-#{url_id}.png"))
      asset.image = file
      file.close
      asset.save!
      original_url_number = asset.url.match(/\d+$/)[0]
      new_url = asset.url.gsub(original_url_number, url_id.to_s)
      asset.update_columns({url: asset.url.gsub(original_url_number, url_id.to_s), asset_url_id: url_id})
      visit = FactoryGirl.create(:visit, agent: agent)
      visit.asset_id_array_will_change!
      visit.asset_id_array.push(asset.asset_url_id)
      visit.save
    end
  end

  def tear_down_complete_dataset
    stub_paperclip_s3_head("asset", "image", "png")
    stub_paperclip_s3_delete("asset", "image", "png")
    @company.destroy
    @agent.destroy
    @superagent.destroy
    @admin.destroy
    @uber_admin.destroy
  end
end

RSpec.configure do |config|
  config.include FeatureMacros
end