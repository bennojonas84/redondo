require 'spec_helper'

describe Agent do

  describe "send_reconfirmation_instructions" do
  end

  describe "save_profileurl" do

    before { 
      @agent = FactoryGirl.build(:agent_with_attachment)
    }

    it "assigns the photo_url attribute value on save" do
      stub_paperclip_s3('agent','photo', 'jpg')
      expect(@agent.photo_url).to eq(nil)
      @agent.save
      expect(@agent.photo_url).not_to eq(nil)
      expect(@agent.photo_url).to match("https://s3.amazonaws.com/redondo/agents/photos/000/")
    end
  end

  describe "has_no_password?" do

    it "returns false when encrypted_password exists" do
      agent = FactoryGirl.create(:agent)
      expect(agent.has_no_password?).to be_false
    end

    it "returns true when encrypted_password is missing" do
      agent = FactoryGirl.build(:agent, password: nil, password_confirmation: nil)
      expect(agent.has_no_password?).to be_true
    end
  end

  describe "attempt_set_password(params)" do
    let(:new_password_data) { {password: "password", password_confirmation: "password"} }

    it "changes the current password and password_confirmation of an unsaved agent instance with the given ones" do
      agent = FactoryGirl.build(:agent)
      expect(agent.password).to eq("please")
      expect(agent.password_confirmation).to eq("please")
      agent.attempt_set_password(new_password_data)
      expect(agent.password).to eq("password")
      expect(agent.password_confirmation).to eq("password")
    end
  end

  describe "only_if_unconfirmed()" do
  end
end
