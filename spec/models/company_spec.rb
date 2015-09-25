require 'spec_helper'

describe Company do
  describe "save_logo() after_save filer" do
    it "populated the logo column with the uploaded logo attachment url value" do
      company = FactoryGirl.build(:company)
      expect(company.attributes['logo']).to be_nil
      company.save!
      expect(company.attributes['logo']).to eq("/assets/no_image/original/no-image.jpg")
    end
  end
end
