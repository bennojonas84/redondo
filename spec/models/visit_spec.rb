require 'spec_helper'

describe Visit do

  describe "retDataFromBody" do
    context "with assets and tags" do
      subject(:visit) { Visit.find(FactoryGirl.create(:visit).id) }

      specify { expect(visit.images).to be_instance_of(Array) }
      specify { expect(visit.image_count).not_to be_nil }
      specify { expect(visit.image_count).to eq(2) }
      specify { expect(visit.tags).not_to be_nil }
      specify { expect(visit.tags).to eq("pudding") }
      specify { expect(visit.region_id).not_to be_nil }
      specify { expect(visit.sales_rep_id).not_to be_nil }
    end

    context "without assets and tags" do
      subject(:visit) { Visit.find(FactoryGirl.create(:json_simplified_visit_noAssets).id) }

      specify { expect(visit.images).to be_instance_of(Array) }
      specify { expect(visit.images).to eql(["cell_placeholder.png"]) }
      specify { expect(visit.image_count).to eq(1) }
    end

    context "with several assets" do
      subject(:visit) { Visit.find(FactoryGirl.create(:visit_with_several_assets).id) }

      it "sort the images by created_at" do
        expect(visit.images.last.created_at).to eq(1384327259.33636)
      end

      specify { expect(visit.images_with_tags.size).to eq(10) }
    end

    context "with several assets and some don't have created_at field" do
      subject(:visit) { Visit.find(FactoryGirl.create(:visit_with_several_incomplete_assets).id) }

      specify { expect(visit.images.size).to eq(5) }
      specify { expect(visit.images.first.created_at).to eq(0) }

      it "sort the images by created_at, the ones with nil value at the end" do
        expect(visit.images.last.created_at).to eq(1384327259.33636)
      end

    end
  end

  describe ".set_data_from_body" do
    context "with every attributes" do
      subject(:visit) { Visit.find(FactoryGirl.create(:visit).id) }
      specify { expect(visit.images).to be_instance_of(Array) }
      specify { expect(visit.asset_id_array).to eq([1369253809, 1373045015, 1370368869, 1370368869, 1370368848]) }
    end

    context "without asset_id_array in the parsed JSON" do
      subject(:visit) { Visit.find(FactoryGirl.create(:json_simplified_visit_not_archived2).id) }

      specify { expect(visit.asset_id_array).to eq([]) }
    end

    context "without assets" do
      subject(:visit) { Visit.find(FactoryGirl.create(:json_simplified_visit_noAssets).id) }

      specify { expect(visit.images).to be_instance_of(Array) }
      specify { expect(visit.images).to include("cell_placeholder.png") }
      specify { expect(visit.asset_id_array).to eq([]) }
    end

    context "with a array of hashes as json 'assets' key's value" do
      subject(:visit) { Visit.find(FactoryGirl.create(:visit_with_several_assets).id) }

      specify { expect(visit.tags).not_to be_nil }
      specify { expect(visit.tags).to include("cake") }
      specify { expect(visit.tags).to include("pudding") }
    end

    context "with string for assets key" do
      subject(:visit) { Visit.find(FactoryGirl.create(:visit_with_old_asset_structure).id) }

      specify { expect(visit.tags).to eq("") }
    end
  end

  describe "build_image_models(json_parsed_array)" do
    subject(:visit) { Visit.new }

    context "with a well formed parsed json array" do
      before(:each) do
        @json_parsed_array = ActiveSupport::JSON.decode(photos_json)
      end
      
      it "returns an array of Image model objects" do
        result = visit.build_image_models(@json_parsed_array)
        expect(result).to be_kind_of(Array)
        expect(result).not_to be_empty
      end
    end

    context 'with an empty array' do
      it "returns an empty array" do
        result = visit.build_image_models([])
        expect(result).to be_kind_of(Array)
        expect(result).to be_empty
      end
    end

    context 'with nil as attribute' do
      it "returns an empty array" do
        result = visit.build_image_models(nil)
        expect(result).to be_kind_of(Array)
        expect(result).to be_empty
      end
    end
  end

  describe ".search(query)" do
    before do 
      FactoryGirl.create_list(:json_simplified_visit, 10)
      FactoryGirl.create_list(:json_simplified_visit_archived, 5)
      Visit.all.to_a
    end

    context "by agent_name" do
      context "in downcase" do
        it "returns only not-archived visits" do
          result = Visit.search("john_")
          expect(result).to be_instance_of(Array)
          expect(result).not_to be_empty
          expect(result.size).to eq(10)
        end
      end

      context "in uppercase" do
        it "finds result too" do
          result = Visit.search("DOE")
          expect(result).not_to be_empty
          expect(result.size).to eq(10)
        end
      end
    end

    context "by title" do
      context "in downcase" do
        it ", find by title" do
          expect(Visit.search("retailer_")).not_to be_empty
          expect(Visit.search("retailer_").size).to eq(10)
        end
      end

      context "in uppercase" do
        it "finds too" do
          expect(Visit.search("RETAILER_")).not_to be_empty
          expect(Visit.search("retailer_").size).to eq(10)
        end
      end
    end

    context "by tags" do
      context "in downcase" do
        it "and finds them" do
          expect(Visit.search("puddi")).not_to be_empty
          expect(Visit.search("pudd").size).to eq(10)          
        end
      end

      context "in uppercase" do
        it "and finds them" do
          expect(Visit.search("PUDD").size).to eq(10)
        end
      end
    end

    context "by comment" do
      context "in downcase" do
        it "and finds them" do
          pending("TODO")
        end
      end

      context "in uppercase" do
        it "and finds them" do
          pending("TODO")
        end
      end
    end
  end

  describe ".sort_visits_by_param(visits=[], params={})" do
    let(:amelie) { FactoryGirl.create(:agent, first_name: 'Amelie') }
    let(:william) { FactoryGirl.create(:agent, first_name: 'William') }

    before do
      FactoryGirl.create_list(:json_simplified_visit_not_archived, 5, agent: amelie)
      FactoryGirl.create_list(:json_simplified_visit_not_archived, 5, agent: william)
    end

    context "by location" do
      context "with asc direction" do
        it "sorts the visits by location in ascending order" do
          visits = amelie.visits
          result = Visit.sort_visits_by_param(visits, {sort: "location", direction: 'asc'} )
          expect(result).to be_kind_of(Array)
          expect(result).not_to be_empty
        end
      end

      context "with desc direction" do
        it "sorts the visits by location in descending order" do
          visits = amelie.visits
          result = Visit.sort_visits_by_param(visits, {sort: "location", direction: 'desc'} )
          expect(result).to be_kind_of(Array)
          expect(result).not_to be_empty
        end
      end
    end

    context "by image_count" do
      context "with asc direction" do
        it "sorts the visits by imagecount in ascending order" do
          visits = amelie.visits
          result = Visit.sort_visits_by_param(visits, {sort: "image_count", direction: 'asc'})
          first_result_id = result.first.id
          last_result_id = result.last.id
          expect(Visit.find(first_result_id).image_count).to be_within(3).of(0)
          expect(Visit.find(last_result_id).image_count).to be_within(3).of(6)
        end
      end

      context "with desc direction" do
        it "sorts the visits by image_count in descending order" do
          visits = william.visits
          result = Visit.sort_visits_by_param(visits, {sort: "image_count"})
          first_result_id = result.first.id
          last_result_id = result.last.id
          expect(Visit.find(first_result_id).image_count).to be_within(3).of(6)
          expect(Visit.find(last_result_id).image_count).to be_within(3).of(0)
        end
      end
    end

    context "by agent_name" do
      context "with asc direction" do
        it "sorts the visits by agent_name in ascending order" do
          visits = Visit.all.to_a
          result = Visit.sort_visits_by_param(visits, {sort: "agent_name", direction: 'asc'})
          first_result_id = result.first.id
          last_result_id = result.last.id
          expect(Visit.find(first_result_id).agent_name).to match(/Amelie/)
          expect(Visit.find(last_result_id).agent_name).to match(/William/)
        end
      end

      context "without direction - aka - with desc direction" do
        it "sorts the visits by agent_name in descending order" do
          visits = Visit.all.to_a
          result = Visit.sort_visits_by_param(visits, {sort: "agent_name"})
          first_result_id = result.first.id
          last_result_id = result.last.id
          expect(Visit.find(first_result_id).agent_name).to match(/William/)
          expect(Visit.find(last_result_id).agent_name).to match(/Amelie/)
        end
      end
    end

    context "by createdAt" do
      context "with asc direction" do
      end
      context "without asc direction" do
      end
    end
  end

  describe "#avg_rating" do
    it "calculates the average of visit_enthusiasm and visit_quality " do
      visit = Visit.find(FactoryGirl.create(:visit).id)
      result = visit.avg_rating
      expect(result).to eq(5)
      visit.update(visit_enthusiasm: 1)
      expect(visit.avg_rating).to eq(3)
    end

    context "when one of the rating is nil" do
      it "calculates the average by replacing nil by 0" do
        visit = Visit.find(FactoryGirl.create(:visit).id)
        visit.update(visit_quality: nil)
        result = visit.avg_rating
        expect(result).to eq(3)
        visit.update(visit_enthusiasm: nil)
        expect(visit.avg_rating).to eq(0)
      end
    end
  end

  let(:visit) { Visit.find(FactoryGirl.create(:visit).id) }

  describe "#complete_address" do
    it "returns the visit's full address" do
      expect(visit.complete_address).to eq("20356 Pacific Coast Hwy Malibu 90265 California")
    end
  end

  describe "#creation_date" do
    it "returns the visit's creation_time as a Date instance" do
      expect(visit.creation_date).to eq(visit.creation_time.to_date)
    end
  end

  describe "#creation_week" do
    it "returns the visit's creation time week number" do
      expect(visit.creation_week).to eq("44")
    end
  end

  describe "#creation_month" do
    it "returns the visit's creation time month number" do
      expect(visit.creation_month).to eq("11")
    end
  end

  describe "#creation_year" do
    it "returns the visit's creation_time year" do
      expect(visit.creation_year).to eq("2013")
    end
  end

  let(:company) { FactoryGirl.create(:company) }
  let(:asset) { 
    FactoryGirl.create(:asset, filename: "Polar_Shock_Cup_Rack_Transparent_Scale.png",
      file_extension: "png", company: company, image: paperclip_fixture("asset", "image", "png"), percent_lift: 25) 
  }
  let(:asset2) { 
    FactoryGirl.create(:asset, filename: "Panneau_affichage_liege_grande_taille.png",
      file_extension: "png", company: company, image: paperclip_fixture("asset", "image", "png"), percent_lift: 35) 
  }
  let(:asset3) { 
    FactoryGirl.create(:asset, filename: "Panneau_affichage_liege_taille_moyenne.png",
      file_extension: "png", company: company, image: paperclip_fixture("asset", "image", "png"), percent_lift: 15) 
  }

  describe "#assets_images_combination" do

    let(:asset_id) { asset.asset_url_id }
    let(:asset2_id) { asset2.asset_url_id }
    let(:asset3_id) { asset3.asset_url_id }

    before do
      new_time = Time.local(2013,11,3,0,0)
      Timecop.freeze(new_time)
    end

    context "when associations exist" do
      let(:visit) { 
        FactoryGirl.create(:empty_visit_to_customize, image_count: 3, body: {archived?: 0, created_at: Time.now, name: "retailer_name_x", photos: [{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 1, tags: ["asset1"], asset_ids: [asset_id]},{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-1.jpg", has_thumb?: 0, tags: ["asset2"], asset_ids: [asset2_id]},
            {remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-2.jpg", has_thumb?: 0, tags: ["asset3"], asset_ids: [asset2_id, asset3_id]}] }.to_json)
      }

      it "associates the visit's asset with the images" do
        _visit = Visit.find(visit.id)

        expect(_visit.assets_images_combination).to have_key(asset)
        expect(_visit.assets_images_combination).to have_key(asset2)
        expect(_visit.assets_images_combination).to have_key(asset3)
        expect(_visit.assets_images_combination[asset]).to include(_visit.images.first)
        expect(_visit.assets_images_combination[asset2]).to include(_visit.images.second)
        expect(_visit.assets_images_combination[asset3]).to include(_visit.images.third)
      end
    end

    context "visit has got empty asset_id_array" do
      let(:visit) { 
        FactoryGirl.create(:empty_visit_to_customize, image_count: 3, body: {archived?: 0, created_at: Time.now, name: "retailer_name_x", photos: [{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 1, tags: ["asset1"], asset_ids: []},{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 0, tags: ["asset2"], asset_ids: []},
            {remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 0, tags: ["asset3"], asset_ids: []}] }.to_json)
      }

      it "returns an empty hash" do
        _visit = Visit.find(visit.id)
        expect(_visit.assets_images_combination).to eql({})
      end
    end

    after do
      Timecop.return
    end
  end

  describe "#percent_lift_sum" do
    let(:asset_id) { asset.asset_url_id }
    let(:asset2_id) { asset2.asset_url_id }
    let(:visit) { 
      FactoryGirl.create(:empty_visit_to_customize, body: {archived?: 0, created_at: Time.now, visit_name: company.name, retailer_info: "retailer_name_x", assets: [{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 1, tag_array: ["pudding", "cake"], asset_id_array: [asset_id, asset2_id]},{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 0, tag_array: ["groseille"], asset_id_array: [asset2_id]},
        {remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 0, tag_array: ["groseille"], asset_id_array: []}] }.to_json, asset_id_array: [asset_id, asset2_id, asset2_id])
    }

    it "sums the asset_id_array corresponding assets's percent_lift" do
      expect(visit.assets_percent_lift_sum).to eql(95)
    end
  end

  describe "#zip_download_images" do

    context 'without selected images' do
      let(:visit) { FactoryGirl.create(:visit) }

      before(:each) do
        visit.retDataFromBody
      end

      it "zip the tempdirs structure recursively" do
        result = visit.zip_download_images
        expect(File.exists?("#{Rails.root}/tmp/#{visit.retailer_name.gsub(/ /,'_')}.zip")).to be_true
        expect(File.size("#{Rails.root}/tmp/#{visit.retailer_name.gsub(/ /,'_')}.zip")).to be > 0
      end

      it "returns the zip file path" do
        result = visit.zip_download_images
        expect(result).to eq("#{Rails.root}/tmp/#{visit.retailer_name.gsub(/ /,'_')}.zip")
      end
    end

    context 'with selected images' do
      let(:visit) { FactoryGirl.create(:empty_visit_to_customize, body: {archived?: 0, created_at: Time.now, visit_name: company.name, name: "retailer_name_x", photos: [{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 1, tags: ["asset1"], asset_ids: []},{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 0, tags: ["asset2"], asset_ids: []},{remote_url: "https://s3.amazonaws.com/visits.retailmapper.com/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 0, tags: ["asset3"], asset_ids: []}] }.to_json) }

      before(:each) do
        visit.retDataFromBody
        visit.images.first.to_download = true
      end

      it "returns the zip file path" do
        result = visit.zip_download_images([visit.images.first])
        expect(result).to eq("#{Rails.root}/tmp/#{visit.retailer_name}_selection.zip")
      end
    end
  end

end
