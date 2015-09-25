require 'spec_helper'
include Devise::TestHelpers

describe VisitsHelper do

  describe "show_agent_name(visit)" do
    context "an admin agent is logged in" do
      login_admin_agent
      let(:visit) { Visit.find(FactoryGirl.create(:visit, agent: @agent).id) }

      it "returns the visit agentName" do
        expect(helper.show_agent_name(visit)).not_to be_nil
      end
    end

    context "a simple agent is logged in" do
      login_agent
      let(:visit) { Visit.find(FactoryGirl.create(:visit, agent: @agent).id)}

      it "returns nil" do
        expect(helper.show_agent_name(visit)).to be_nil
      end
    end

    context "an admin is logged in" do
      login_admin
      let(:visit) { Visit.find(FactoryGirl.create(:visit).id) }

      it "returns the visit agentName" do
        expect(helper.show_agent_name(visit)).not_to be_nil
      end
    end
  end

  describe "thumb_image(image)" do
    context "the asset has thumb version" do
      let(:visit) { Visit.find(FactoryGirl.create(:visit).id) }

      it "returns the thumb image url" do
        asset = visit.images.first
        expect(helper.thumb_image(asset)).to eq("https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2F48506C75-4E8F-4F9E-A594-66582EDFD405-0_thumb.jpg")
      end
    end

    context "the asset doesn't have thumb version" do
      let(:visit) { Visit.find(FactoryGirl.create(:visit_asset_no_thumb).id) }

      it "returns the image url" do
        asset = visit.images.first
        expect(helper.thumb_image(asset)).to eq("https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg")
      end
    end

    # context "the asset complies to old data structure" do
    #   let(:visit) { Visit.find(FactoryGirl.create(:visit_with_old_asset_structure).id) }

    #   it "returns the image url" do
    #     asset = visit.images.first
    #     expect(helper.thumb_image(asset)).to eq("https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg")
    #   end
    # end

    context "with default missing image : 'cell_placeholder.png' " do
      let(:visit) { Visit.find(FactoryGirl.create(:json_simplified_visit_noAssets).id) }

      it "returns the image url" do
        asset = visit.images.first
        expect(helper.thumb_image(asset)).to eq("cell_placeholder.png")
      end
    end
  end

  describe "image_tags(image)" do
    context "the image is a Hash with tag_array key" do
      let(:visit) { Visit.find(FactoryGirl.create(:visit).id) }

      it "returns the tags_array content as string" do
        expect(helper.image_tags(visit.images.first)).to eq("pudding") 
      end
    end
  end

  describe "formatted_rating(rating)" do
    context "with nil value" do
      it "returns 0" do
        expect(helper.formatted_rating(nil)).to eq(0)
      end
    end
  end

  describe "formatted_time(datetime)" do
    it "should description" do
      
    end
  end
end
