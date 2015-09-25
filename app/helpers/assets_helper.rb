module AssetsHelper
  def visits_for(asset, options={})
    asset.url.match(/\d+$/) do |match|
      visits = Visit.where("#{match[0].to_i} = ANY (asset_id_array)").not_archived
      visit_ids = visits.collect(&:id)
      return visit_ids.present? ? (link_to "VISITS #{visit_ids.size}", assetvisits_path({id: asset.id, visit_ids: visit_ids.join(',')}.merge!(options)), class: 'default-link') : "VISITS 0"
    end
    return "VISITS 0"
  end
end
