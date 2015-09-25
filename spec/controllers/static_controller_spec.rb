require 'spec_helper'

describe StaticController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'tutorials'" do
    it "returns http success" do
      get 'tutorials'
      response.should be_success
    end
  end

  describe "GET 'white_paper'" do
    it "returns http success" do
      get 'white_paper'
      response.should be_success
    end
  end

  describe "GET 'videos'" do
    it "returns http success" do
      get 'videos'
      response.should be_success
    end
  end

  describe "GET 'reports'" do
    it "returns http success" do
      get 'reports'
      response.should be_success
    end
  end

end
