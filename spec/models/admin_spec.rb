require 'spec_helper'

describe Admin do
  describe "is_uber_admin?" do
    subject(:uber_admin) { FactoryGirl.create(:uber_admin) }
    specify { expect(uber_admin.is_uber_admin?).to eq(true) }

    subject(:dev_admin) { FactoryGirl.create(:developer_admin) }
    specify { expect(dev_admin.is_uber_admin?).to eq(false) }
  end

  describe ".assigned_to_company scope" do
    let(:company) { FactoryGirl.create(:company) }

    before(:each) do
      @assigned_admin = FactoryGirl.create(:uber_admin)
      @current_admin = FactoryGirl.create(:uber_admin)
      @assigned_admin.company_ids_will_change!
      @assigned_admin.company_ids.push(company.id)
      @assigned_admin.save!
      @current_admin.company_ids_will_change!
      @current_admin.company_ids.push(company.id)
      @current_admin.save!
    end

    it "returns all admins with the given company_id" do
      result = Admin.assigned_to_company(company.id)
      expect(result.length).not_to eql(0)
      expect(result.length).to eql(2)
    end
  end

  describe ".already_assigned(company_id, current_admin)" do
    let(:company) { FactoryGirl.create(:company) }

    context 'when company has been already assigned to another uber admin ' do
      before(:each) do
        @assigned_admin = FactoryGirl.create(:uber_admin)
        @current_admin = FactoryGirl.create(:uber_admin)
        @assigned_admin.company_ids_will_change!
        @assigned_admin.company_ids.push(company.id)
        @assigned_admin.save!
      end

      it "returns true" do
        expect(Admin.uber_admins.count).to eql(2)
        result = Admin.already_assigned(company.id)
        expect(result).to eq(true)
      end
    end

    context 'when company is not yet assigned' do
      it "returns false" do
        @current_admin = FactoryGirl.create(:uber_admin)
        result = Admin.already_assigned(company.id)
        expect(result).to eql(false)
      end
    end
  end

  describe "add_company_id(company_id)" do
    
    let(:company) { FactoryGirl.create(:company) }

    context 'when company is not already assigned' do
      it "records the given company id in the admin company_ids array attribute" do
        current_admin = FactoryGirl.create(:uber_admin)
        expect(current_admin.company_ids).to be_empty
        current_admin.add_company_id(company.id)
        expect(current_admin.company_ids).not_to be_empty
      end
    end

    context 'when company is already assigned to a uber admin' do
      before(:each) do
        @assigned_admin = FactoryGirl.create(:uber_admin)
        @assigned_admin.company_ids_will_change!
        @assigned_admin.company_ids.push(company.id)
        @assigned_admin.save!
      end

      it "doesn't record the given company id the current admin company_ids" do
        current_admin = FactoryGirl.create(:uber_admin)
        expect(current_admin.company_ids).to be_empty
        current_admin.add_company_id(company.id)
        expect(current_admin.company_ids).to be_empty
      end
    end
  end

  describe "remove_company_id(company_id)" do
    let(:company) { FactoryGirl.create(:company) }

    before(:each) do
      @current_admin = FactoryGirl.create(:uber_admin)
      @current_admin.add_company_id(company.id)
    end

    it "removes the given company id from company_ids" do
      expect(@current_admin.company_ids).not_to be_empty
      @current_admin.remove_company_id(company.id)
      expect(@current_admin.company_ids).to be_empty
    end
  end
end
