module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      @admin = FactoryGirl.create(:admin)
      sign_in @admin # Using factory girl as an example
    end
  end

  def login_agent
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:agent]
      @agent = FactoryGirl.create(:agent)
      @agent.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
      sign_in @agent
    end
  end

  def login_admin_agent
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:agent]
      @agent = FactoryGirl.create(:admin_agent)
      @agent.confirm!
      sign_in @agent
    end
  end
end