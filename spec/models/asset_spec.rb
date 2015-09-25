require 'spec_helper'

describe Asset do
  describe "validates the percent_lift attribute" do
    it "has to be a number" do
      asset = Asset.new
      expect(asset).to be_valid
      asset.percent_lift = "abc"
      expect(asset).not_to be_valid
      expect(asset.errors.messages[:percent_lift]).to eq(["is not a number", "is not included in the list"])
    end

    it "has to be between 1 and 100" do
      asset = Asset.create(percent_lift: 110)
      expect(asset.errors.messages[:percent_lift]).to eq(["is not included in the list"])
      asset.percent_lift = 0
      expect(asset.errors.messages[:percent_lift]).to eq(["is not included in the list"])
    end
  end
  describe "save_url after_filter" do
    it "populates the url column with the uploaded image attachment url" do
      stub_paperclip_s3("asset", "image", "png")
      asset = FactoryGirl.build(:asset, image: paperclip_fixture("asset", "image", "png"))
      expect(asset.url).to be_nil
      asset.save!
      expect(asset.url).to match(/https:\/\/s3.amazonaws.com/)
      expect(asset.asset_url_id).not_to be_nil
    end
  end
end
