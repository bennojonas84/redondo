require 'spec_helper'

describe ReportsHelper do
  describe "human_readable(week,year)" do
    it "returns human readable week dates" do
      result = helper.human_readable_week(36,2013)
      expect(result).to eq("2013-09-09 - 2013-09-15")
    end
  end
end
