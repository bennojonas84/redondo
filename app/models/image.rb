class Image
  include ActiveModel::Model
  attr_accessor :created_at, :tags, :visit_id, :asset_ids, :remote_url, :has_thumb, :to_download, :sortOrder
  
  def initialize(attributes={})
    super
    @to_download ||= false
    @visit_id ||= nil
    @tags ||= []
    @created_at ||= 0
    @has_thumb ||= false
    @asset_ids ||= []
    @sortOrder ||= 0
  end

  def to_download?
    @to_download
  end

end