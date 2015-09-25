FactoryGirl.define do
  factory :asset do
    filename "sample"
    file_extension "png"
    description "a shop looking like a river"
    url nil
    image nil
    percent_lift 15
    asset_url_id 1383451200

    company

    factory :empty_asset do
      image nil
    end
  end
end

# asset_url_id sample
# 1369253809, 1373045015, 1370368869, 1370368848