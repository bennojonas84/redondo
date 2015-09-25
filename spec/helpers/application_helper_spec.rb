require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  describe "resource_name" do
    it "returns :agent symbol" do
      expect(helper.resource_name).to eq(:agent)
    end
  end

  describe "resource" do
    it "returns a new Agent instance as @resource" do
      expect(helper.resource).to be_instance_of(Agent)
    end
  end

  describe "devise_mapping" do
    it "returns a devise mapping object for the agent resource" do
      expect(helper.devise_mapping.name).to eq(:agent)
      expect(helper.devise_mapping.to).to eq(Agent)
    end
  end

  describe "sortable(column, title = nil)" do

    context "agentvisits view template" do

      context "without sort parameter" do
        it "builds a link to /agentvisits with the following parameters {direction:asc, class:default-sort-link, id:41, page:1, sort: title}" do
          helper.stub(:sort_column).and_return("id")
          helper.stub(:params).and_return({id: "41", controller: "visits", action: "agentvisits"}.with_indifferent_access)

          result = helper.sortable("title", "TITLE")
          expect(result).to eq('<a class="default-sort-link" href="/agentvisits?direction=asc&amp;id=41&amp;page=1&amp;sort=title">TITLE</a>')
        end
      end

      context "with 'title' sort parameter" do
        it "builds a link to /agentvisits with the following parameters: { class: default-sort-link asc, direction: desc, id:41, page:1, sort:title }" do
          helper.stub(:sort_column).and_return("title")
          helper.stub(:sort_direction).and_return("asc")
          helper.stub(:params).and_return({id: "41", controller: "visits", action: "agentvisits"}.with_indifferent_access)

          result = helper.sortable("title", "TITLE")
          expect(result).to eq('<a class="default-sort-link asc" href="/agentvisits?direction=desc&amp;id=41&amp;page=1&amp;sort=title">TITLE</a>')
        end
      end

      context "with 'title' sort parameter and 'desc' direction parameter" do
        it "builds a link to /agentvisits with the following parameters: { class: default-sort-link asc, direction: desc, id:41, page:1, sort:title }" do
          helper.stub(:sort_column).and_return("title")
          helper.stub(:sort_direction).and_return("desc")
          helper.stub(:params).and_return({id: "41", controller: "visits", action: "agentvisits"}.with_indifferent_access)

          result = helper.sortable("title", "TITLE")
          expect(result).to eq('<a class="default-sort-link desc" href="/agentvisits?direction=asc&amp;id=41&amp;page=1&amp;sort=title">TITLE</a>')
        end
      end

    end    
  end
end
