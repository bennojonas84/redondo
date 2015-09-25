module StaticHelper
  def video_gallery_link_no_tags(asset)
    link_to downloadable_url(asset), {class: "fancybox no-bg", rel: "group1"} do
      image_tag asset, class: "image-responsive"
    end
  end
end
