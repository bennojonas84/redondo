module VisitsHelper
  def show_agent_name(visit)
    ((current_agent && current_agent.asadmin?) || current_admin) ? visit.agent_name : nil
  end

  def thumb_image(image)
    if image.is_a?(Image)
      if image.has_thumb == 1 || image.has_thumb == true
        match_string = image.remote_url.match(/(.jpg)|(.png)/)
        image_name = match_string.try(:pre_match)
        extension = match_string[0]
        return (image_name.try(:+,"_thumb#{extension}"))
      else
        return image.remote_url
      end
    else
      return image
    end
  end

  def downloadable_url(image)
    image.is_a?(Image) ? image.remote_url : image    
  end

  def image_tags(image)
    image.tags && !image.tags.empty? ? image.tags.join(" , ") : raw('&nbsp;')
  end

  def formatted_rating(rating)
    rating.nil? ? 0 : number_with_precision(rating, precision: 0)
  end

  def image_gallery_link(asset)
    if image_tags(asset) == "&nbsp;"
      link_to downloadable_url(asset), {class: "fancybox no-bg", rel: "group1"} do
        image_tag thumb_image(asset), class: "image-rounded large_thumb img-thumbnail"
      end
    else
      link_to downloadable_url(asset), {class: "fancybox no-bg", rel: "group1", title: "#{image_tags(asset)}"} do
        image_tag thumb_image(asset), class: "image-rounded large_thumb img-thumbnail"
      end
    end
  end

  def visit_image_gallery_link_no_tags(asset)
    if image_tags(asset) == "&nbsp;"
      link_to downloadable_url(asset), {class: "fancybox no-bg", rel: "group1"} do
        image_tag thumb_image(asset), class: "image-rounded thumb"
      end
    else
      link_to downloadable_url(asset), {class: "fancybox no-bg", rel: "group1", title: "#{image_tags(asset)}"} do
        image_tag thumb_image(asset), class: "image-rounded thumb"
      end
    end
  end

  def image_gallery_link_no_tags(asset)
    if image_tags(asset) == "&nbsp;"
      link_to downloadable_url(asset), {class: "fancybox no-bg", rel: "group1"} do
        image_tag thumb_image(asset), class: "image-rounded thumb_export img-thumbnail"
      end
    else
      link_to downloadable_url(asset), {class: "fancybox no-bg", rel: "group1", title: "#{image_tags(asset)}"} do
        image_tag thumb_image(asset), class: "image-rounded thumb_export img-thumbnail"
      end
    end
  end

  def formatted_time(datetime)
    datetime.in_time_zone('EST').strftime("%B %d, %Y, %H:%M")
  end

  def download_zip_link(visit)
    link_to download_zipped_images_visit_path(visit, selection: false, format: :zip), {class: 'btn btn-primary pull-left', id: 'download_all'} do
      concat(content_tag(:i,'', class: 'glyphicon glyphicon-download'))
      concat(" Download All")
    end 
  end

  def download_selection_zip_link(visit)
    link_to download_zipped_images_visit_path(visit, selection: true, format: :zip), {class: "btn btn-success pull-right", id: 'download_selection'} do
      concat(content_tag(:i,'', class: 'glyphicon glyphicon-download'))
      concat(" Download Selected")
    end 
  end
end
