require "spec_helper"

describe "Admin manages Agent under SuperAgent identity" do
  subject {page}

  describe "Admin creates agent" do
    before do
      stub_paperclip_s3("asset", "image", "png")
      admin_with_companies_and_company_user_login
      @company = Company.first
      @superagent = @company.agents.first
    end

    it "by choosing a company to manage, clicking on the Agents side menu link and the Add Agent button" do
      pending()
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      all('a.btn')[1].click()
    
      click_link("New Agent")

      fill_in "agent_first_name", with: "Homer"
      fill_in "agent_last_name", with: "Simpson"
      fill_in "agent_email", with: "homer.simpson@skurun.com"
      find("input[value=Invite]").click()

      expect(@company.agents.size).to eq(2)
      expect(@company.agents.last.email).to eq "homer.simpson@skurun.com"
    end

    it "and record creation in History under Admin ID", js: true do
      pending "find why history record is not created"
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      all('a.btn')[1].click()
    
      click_link("New Agent")

      fill_in "agent_first_name", with: "Homer"
      fill_in "agent_last_name", with: "Simpson"
      fill_in "agent_email", with: "homer.simpson@skurun.com"
      find("input[value=Invite]").click()

      expect(History.count).to eq(1)
      history = History.first
      expect(history.active_name).to eq(@admin.email)
      expect(history.action).to eq("create")
      expect(history.sort).to eq("agent")
      expect(history.passive_name).to eq("homer.simpson@skurun.com")
    end
  end

  describe "Admin updates Agent informations" do
    before do
      stub_paperclip_s3("asset", "image", "png")
      admin_with_companies_and_company_user_login
      @company = Company.first
      @superagent = @company.agents.first
    end

    it "by choosing a company to manage and clicking on an Agent name", js: true, driver: :poltergeist do
      pending()
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      all('a.btn')[1].click()
      all("td.show-agent-form")[1].click()
      find("form.edit_agent").should be_visible

      fill_in "agent_first_name", with: "Bart"
      fill_in "agent_last_name", with: "Simpson"
      fill_in "agent_email", with: "bart.simpson@skurun.com"
      find("input[value='Update']").click()

      expect(page).to have_text("Bart Simpson")
      expect(page).to have_text @company.agents.first.email
      expect(page).not_to have_text "bart.simpson@skurun.com"
      expect(@company.agents.where(unconfirmed_email: "bart.simpson@skurun.com")).not_to be_empty
    end

    it "and History record is created for Admin action", js:true do
      pending "check with history record is not created"
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      all('a.btn')[1].click()
      all("td.show-agent-form")[1].click()
      find("form.edit_agent").should be_visible

      fill_in "agent_first_name", with: "Bart"
      fill_in "agent_last_name", with: "Simpson"
      fill_in "agent_email", with: "bart.simpson@skurun.com"
      find("input[value='Update']").click()

      expect(History.count).to eq(1)
      history = History.first
      expect(history.active_name).to eq(@admin.email)
      expect(history.action).to eq("update")
      expect(history.sort).to eq("agent")
      expect(history.passive_name).to eq(@company.agents.first.email)
    end
  end

  describe "Admin re-confirm agent credentials" do
    before do
      stub_paperclip_s3("asset", "image", "png")
      admin_with_companies_and_company_user_login
      @company = Company.first
      @superagent = @company.agents.first
      @initial_password = @superagent.password
    end

    it "by choosing a company to manage and clicking on an Agent name then following the re-confirm agent credentials", js: true do
      pending()
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      initial_password = @superagent.password

      all('a.btn')[1].click()
      all("td.show-agent-form")[1].click()
      find("form.edit_agent").should be_visible
      click_link "Re-Confirm Agent Credentials"

      expect(@superagent.reload.confirmed_at).to eq nil
      expect(@superagent.reload.password).to eq initial_password
    end
  end

  describe "Admin deletes Agent" do
    before do
      stub_paperclip_s3("asset", "image", "png")
      admin_with_companies_and_company_user_login
      @company = Company.first
      @superagent = @company.agents.first
      @email = @superagent.email
    end

    it "by choosing a company to manage and clicking on an Agent name",js: true, driver: :poltergeist do
      pending()
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      all('a.btn')[1].click()
      all("td.show-agent-form")[1].click()
      find("form.edit_agent").should be_visible
      click_link "Delete"
      
      expect(page).not_to have_text(@superagent.email)
      expect(@company.agents.size).to eq(0)
    end

    it "and records the agent deletion in History under Admin ID", js: true do
      pending "check why history record is not created"
      expect(page).to have_selector('a.btn', text: "Manage", count: 2)
      all('a.btn')[1].click()
      all("td.show-agent-form")[1].click()
      find("form.edit_agent").should be_visible
      click_link "Delete"

      expect(History.count).to eq(1)
      history = History.first
      expect(history.active_name).to eq(@admin.email)
      expect(history.action).to eq("destroy")
      expect(history.sort).to eq("agent")
      expect(history.passive_name).to eq(@email)
    end
  end
end