require 'spec_helper'

describe AssetsHelper do
  let(:company) { FactoryGirl.create(:company) }
  let(:agent) { FactoryGirl.create(:agent, company: company) }
  let(:asset) { FactoryGirl.create(:asset, filename: "Polar_Shock_Cup_Rack_Transparent_Scale.png",
        file_extension: "png",
        company: company, 
        image: paperclip_fixture("asset", "image", "png"))  
  }

  describe "visits_for(asset)" do
    context "with corresponding visit" do
      before do
        @visit = FactoryGirl.create(:json_simplified_visit_not_archived, agent: agent)
        @visit.asset_id_array_will_change!
        @visit.asset_id_array += [asset.url.match(/\d+$/)[0].to_i]
        @visit.save
        @visit
      end

      it "returns a link to assetvisits page with the visits count" do
        result = helper.visits_for(asset)
        expect(result).to eq("<a class=\"default-link\" href=\"/assetvisits?id=1&amp;visit_ids=1\">VISITS 1</a>")
      end
    end

    context "without corresponding visit" do
      before do
        @visit = FactoryGirl.create(:json_simplified_visit_not_archived2, agent: agent)
      end

      it "should not display any link" do
        result = helper.visits_for(asset)
        expect(result).to eq("VISITS 0")
      end
    end
  end
end