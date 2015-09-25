require 'spec_helper'

describe "Activity Log" do
  subject { page }

  describe "Admin knows when a visits is viewed" do
    before do
      PublicActivity.with_tracking do
        agent_views_a_visit_detail_page
        admin_without_company_login
      end
    end

    it "by seeing an activity log related to this agent's visit" do
      visit '/rm/SkuRun/activities'
      page.should have_content('Activities')
      page.should have_content("#{@agent.fullname} looked at visit #{@agent.visits.first.title}")
    end
  end

  describe "Admin knows when a visit's images are downloaded" do
    before do
      PublicActivity.with_tracking do
        agent_views_a_visit_and_download_images
        admin_without_company_login
      end
    end

    it "by seeing an activity log entry for the afore mentioned action" do
      visit '/rm/SkuRun/activities'
      page.should have_content("#{@agent.fullname} downloaded all visit's images #{@agent.visits.first.title} on")
    end
  end
end