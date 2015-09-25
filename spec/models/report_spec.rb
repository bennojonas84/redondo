require 'spec_helper'

describe Report do
  describe ".visits_for_company(company_id)" do
    let(:company) { FactoryGirl.create(:company_with_agents_and_visits) }

    it "returns a Hash object with the company name and its visits array" do
      result = Report.visits_for_company(company.id)  
      expect(result[:company_name]).to match('company_')
      expect(result[:array].size).to eq(2)
    end
  end

  describe "self.company_visits_by_year_delimited(company_id, start_date=nil, end_date=nil)" do
    context "without dates delimitations" do
      let(:company) { FactoryGirl.create(:company_with_agents_and_visits) }

      it "returns a Hash object with the company's visits grouped by year" do
        result = Report.company_visits_by_year_delimited(company.id)
        expect(result).to be_kind_of(Hash)
        expect(result).to have_key(2013)
        expect(result[2013]).to include(company.visits.first)
      end
    end

    context "with date delimitations" do
      let(:company) { FactoryGirl.create(:company_with_agents_and_visits) }

      it "which include visits returns a Hash object with the company's visits grouped by year for the given period" do
        
      end

      it "which doesn't include visits, returns an empty Hash" do
        result = Report.company_visits_by_year_delimited(company.id, 2.years.ago, 1.year.ago)
        expect(result).to be_kind_of(Hash)
        expect(result).to be_empty
      end
    end
    
  end

  describe "self.company_visits_per_period(company_id, period='month')" do
    let(:company) { FactoryGirl.create(:company_with_agents_and_visits) }
    context "per month" do
      it "count the visits for a given company by year then month" do
        result = Report.company_visits_per_period(company.id, "month")
        expect(result).to eq([[2013,[["2013-11-01",2]]]])        
      end
    end
    context "per week" do
      it "count the visits for a given company by year then week" do
        pending()
        result = Report.company_visits_per_period(company.id, "week")
        expect(result).to eq([[2013,[["37",2]]]])
      end
    end
  end

  describe "self.generate_for_company(company)" do
    context "which has got agents and visits" do
      let(:company) { FactoryGirl.create(:company_for_report_testing2) }

      it "returns an hash object" do
        result = Report.generate_for_company(company)
        expect(result).to be_kind_of Hash
      end

      it "returns the company name" do
        result = Report.generate_for_company(company)
        expect(result[:company].name).to match('company_')
      end

      it "calculates the number of visits per month" do
        result = Report.generate_for_company(company)
        expect(result).to have_key(:visits_per_month)
      end

      it "calculates the number of visits per week" do
        result = Report.generate_for_company(company)
        expect(result).to have_key(:visits_per_week)
        expect(result[:visits_per_week].length).to be_within(1).of(2)
        year = Visit.last.creation_year.to_i
      end

      it "calculates the number of visits per enthusiasm rating" do
        result = Report.generate_for_company(company)    
        expect(result).to have_key(:visits_per_enthusiasm)
      end

      it "calculates the number of visits per quality rating" do
        result = Report.generate_for_company(company)
        expect(result).to have_key(:visits_per_quality)
      end

      it "returns the number of visits per zipcode" do
        result = Report.generate_for_company(company)
        expect(result).to have_key(:visits_per_zipcode)
      end

      it "returns the most active agents per day"

      it "returns the most active agents per month"

      it "returns the most active agents per week"
    end

    context "which hasn't got a single visit" do

    end
  end

  describe "self.today_visits(company, day=Date.today)" do
    let(:company) {FactoryGirl.create(:company_with_agents_and_visits)}

    context "with no day param given" do
      it "returns the today visits count" do
        result = Report.today_visits(company)
        expect(result).to eq(0)
      end
    end

    context "with a given day param" do
      it "returns the visits count for the requested day" do
        date = DateTime.parse("2013-11-06 01:44:19 +0000")
        result = Report.today_visits(company, date)
        expect(result).to eq(2)
      end
    end
  end

  describe "self.company_visits_per_zipcode_per_period(company, zipcode, period={})" do
    let(:company) { FactoryGirl.create(:company) }
    let(:agent) { FactoryGirl.create(:agent, company: company, company_user:true, asadmin: true) }

    before do
      new_time = Time.local(2013,11,3,0,0)
      Timecop.freeze(new_time)
      2.times do |i|
        json = { archived?: 0, created_at: (DateTime.now.utc-i.years).to_i, visit_name: Faker::Company.name, assets: [], retailer_info: {name: "retailer_name_#{i}", zip: "95014" } }.to_json
        visit = Visit.new( agent_id: agent.id, body: json, zipcode: "95014", creation_time: (DateTime.now.utc - i.years) )
        visit.save
      end
    end

    context "without given zipcode nor specific dates" do
      it "returns the visits count for all zipcodes on the past 12 months" do
        result = Report.company_visits_per_zipcode_per_period(company)
        expect(result).to be_kind_of(Array)
        expect(result).to eq([["95014", 2]])
      end
    end

    context "without given zipcode but specific dates" do
      it "returns the visits count for all zipcode on the specific time period" do
        result = Report.company_visits_per_zipcode_per_period(company, nil, {start_date: 3.months.ago, end_date: Time.now.utc})
        expect(result).to be_kind_of(Array)
        expect(result).to eq([["95014", 1]])
      end
    end

    context "with specific zipcode" do
      it "returns the visits count for the given zipcode grouped by year and month on given period" do
        result = Report.company_visits_per_zipcode_per_period(company, "95014")
        expect(result).to be_kind_of(Array)
        expect(result).to eq([[2012, [["2012-11-01", 1]]], [2013, [["2013-11-01", 1]]]])
      end
    end

    context "with 0 visits zipcode" do
      it "returns the visits count for the given zipcode and time period" do
        result = Report.company_visits_per_zipcode_per_period(company, "95013")
        expect(result).to be_kind_of(Array)
        expect(result).to eq([])
      end
    end

    after do
      Timecop.return
    end
  end

  describe "self.company_visits_per_rating(company_id, rating)" do
    let(:company) { FactoryGirl.create(:company_with_agents_and_visits) }

    before do
      new_time = Time.local(2013,11,3,0,0)
      Timecop.freeze(new_time)
    end

    context "with quality rating" do
      it "counts the company visits per visit_quality" do
        result = Report.company_visits_per_rating(company.id)
        expect(result).to be_kind_of(Array)
        expect(result).to eq([[5, 2]])
      end   
    end

    context "with enthusiasm rating" do
      it "counts the company visits per visit_enthusiasm" do
        result = Report.company_visits_per_rating(company.id, "enthusiasm")
        expect(result).to be_kind_of(Array)
        expect(result).to eq([[5, 2]])
      end  
    end

    after do
      Timecop.return
    end
  end

  describe "self.most_active_agents_on_period(company_id, period={})" do
    let(:company) { FactoryGirl.create(:company_with_agents_and_visits) }

    context "with default params" do
      it "groups the given company agents by visits count on the last 12 months" do
        result = Report.most_active_agents_on_period(company)
        expect(result).to be_kind_of(Array)
        expect(result).to eq([[company.agents.first.fullname,2]])
      end
    end
  end
end
