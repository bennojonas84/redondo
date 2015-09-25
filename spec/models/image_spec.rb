require "spec_helper"

describe Image do
  describe "new" do
    context "with correct hash" do
      subject(:image) {
        hash = ActiveSupport::JSON.decode(photos_json).first
        hash[:has_thumb] = hash['has_thumb?']
        hash.delete('has_thumb?')
        Image.new(hash) 
      }

      specify { expect(image.to_download).to eql(false) }
      specify { expect(image.remote_url).not_to be_nil  }
      specify { expect(image.tags).to be_kind_of(Array)  }
      specify { expect(image.asset_ids).to be_kind_of(Array)  }
      specify { expect(image.created_at).not_to be_nil }
      specify { expect(image.has_thumb).to be_true }
      specify { expect(image.visit_id).to be_nil }
    end

    context 'with a hash containing the visit_id key' do
      subject(:image) { 
        hash = ActiveSupport::JSON.decode(photos_json).first
        hash[:has_thumb] = hash['has_thumb?']
        hash.delete('has_thumb?')
        hash[:visit_id] = 106
        Image.new(hash) 
      }

      specify { expect(image.visit_id).not_to be_nil }
      specify { expect(image.visit_id).to eql(106) }
    end

    context 'with an empty hash attribute' do
      subject(:image) { Image.new({}) }
      specify { expect(image.created_at).to eql(0) }
    end

    context 'with a hash without created_at key' do
      subject(:image) { 
        hash = ActiveSupport::JSON.decode(photos_json)[1]
        hash[:has_thumb] = hash['has_thumb?']
        hash.delete('has_thumb?')
        Image.new(hash) 
      }

      specify { expect(image.created_at).to eql(0) }
    end

    context 'with an hash containing only the remote_url' do
      subject(:image) { Image.new({remote_url: "http://url.com"}) }

      specify { expect(image).to be_valid }
      specify { expect(image.asset_ids).to be_empty }
    end
  end
end