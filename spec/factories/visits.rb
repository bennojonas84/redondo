require_relative '../support/json_datas.rb'

FactoryGirl.define do
  VISIT_TYPES = ['Retailer Makeover', 'Retailer Liquidation', 'Retailer Opening']
  
  def generate_assets_array(n)
    arr = []
    n.times do |i|
      arr << { 
        remote_url: "http://assets.image.com/pic_#{i}.png",
        has_thumb?: 1,
        tags: ["pudding", "cake"],
        asset_ids: []
      }
    end
    return arr
  end

  def generate_assets_array_with_nil(n)
    arr = []
    n.times do |i|
      arr << {
        remote_url: "http://assets.image/com/pic_#{i}.png",
        has_thumb?: 1,
        tags: ["pudding, cake"],
        asset_ids: nil
      }
    end
    return arr
  end

  sequence(:title) { |n| "retailer_name_#{n}" }

  sequence(:retailerInfo) { |n| {archived?: 0, visit_type: "Retail Makeover", name: "retailer_name_#{n}", photos: [{remote_url: "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg", has_thumb?: 1, tags: ["pudding"]}]}.to_json }

  sequence(:archived_retailerInfo) { |n| { archived?: 1, created_at: (Time.now - n.days), visit_type: "Retail Makeover", retailer_info: {name: "retailer_name_#{n}"}}.to_json }

  sequence(:not_archived_retailerInfo) { |n| { archived?: 0, created_at: (Time.now - n.days), photos: generate_assets_array(rand(6)), name: "retailer_name_#{n}"}.to_json }

  sequence(:not_archived_retailerInfo2) { |n| { archived?: 0, created_at: (Time.now - n.days), visit_name: Faker::Company.name, visit_type: VISIT_TYPES[rand(VISIT_TYPES.length)], photos: generate_assets_array_with_nil(rand(6)), retailer_info: {name: "retailer_name_#{n}"}}.to_json }

  sequence(:retailerInfo_with_noAssets) { |n| { archived?: 0, created_at: (Time.now - n.days), name: Faker::Company.name, visit_type: VISIT_TYPES[rand(VISIT_TYPES.length)], photos: [], retailer_info: {name: "retailer_name_#{n}"}}.to_json }

  sequence(:retailerInfo_with_noAssets2) { |n| { archived?: 0, created_at: (Time.now - n.weeks).to_i, visit_name: Faker::Company.name, visit_type: VISIT_TYPES[rand(VISIT_TYPES.length)], photos: nil, retailerInfo: {name: "retailer_name_#{n}"}}.to_json }

  sequence(:retailerInfo_with_asset_yearly) { |n| { archived?: 0, created_at: (Time.now - (n-1).year).to_i, visit_name: Faker::Company.name, visit_type: VISIT_TYPES[rand(VISIT_TYPES.length)], photos: generate_assets_array(n), retailerInfo: {name: "retailer_name_#{n}" }}.to_json }

  sequence(:not_archived_nil_created_at) { |n| { archived?:0, created_at: nil, visit_name: Faker::Company.name, visit_type: VISIT_TYPES[rand(VISIT_TYPES.length)], photos: generate_assets_array(rand(6)), retailer_info: {name: "retailer_name_#{n}"}}.to_json }

  def old_visit_json_hash    
  end

  factory :visit do
    name "D252430C-E119-4C0C-B1E5-A9B37FB7C098-5422-00000234A5A6F56C"
    body ::JsonDatas.latest_visit_json
    agent
    archived_status false
    title "Moonshadows Malibu"
    agent_name { "#{agent.first_name}" "#{agent.last_name}" }
    image_count 2
    city "Malibu"
    location nil
    zipcode "90265"
    street "20356 Pacific Coast Hwy"
    state "California"
    latitude "34.037516"
    longitude "-118.618723"
    phone_number "+13104563010"
    url nil
    comment "Add Notes"
    visit_enthusiasm 5
    visit_quality 5
    visit_type nil
    creation_time DateTime.parse("2013-11-06 01:44:19 +0000")
    address "20356 Pacific Coast Hwy Malibu California 90265"
    asset_id_array "{}"
    created_at DateTime.parse("2013-11-06 01:44:19 +0000")
    updated_at DateTime.parse("2013-11-06 01:44:19 +0000")

    factory :visit_with_several_assets do
      body '{
        "archived?":false,
       "user_token":"mhBGnQbAXQ9N335Jypcw",
       "retailer_id":"454545",
       "created_at":"2014-03-26 07:42:38 +0000",
       "comment":"apple hotel?[20741:880f] vImage decode failed, falling back to CG path.\nMar 26 15:42:29 My-Mac.local Retail Mapper[20741] <Error>: CGBitmapContextCreate: unsupported parameter combination: 5 integer bits/component; 16 bits/pixel; 3-component color space; kCGImageAlphaNoneSkipLast; 512 bytes/row.\n2014-03-26 15:42:29.310 Retail Mapper[20741:880f] vImage decode failed, falling back to CG path.\nMar 26 15:42:29 My-Mac.local Retail Mapper[20741] <Error>: CGBitmapContextCreate: unsupported parameter combination: 5 integer bits/component; 16 bits/pixel; 3-component color space; kCGImageAlphaNoneSkipLast; 512 bytes/row.\n2014-03-26 15:42:29.317 Retail Mapper[20741:880f] vImage decode failed, falling back to CG path.\n",
       "visit_token":"B0D3EA85-2A87-4F9D-8707-99F3CC29B37C-20741-0000605821F49D2E",
       "business_id":null,
       "city":"Yichun",
       "latitude":27.807359,
       "local_search_provider_id":"",
       "longitude":114.402601,
       "name":"Apple Hotel",
       "phone_number":"",
        "photos" : [
          {
            "remote_url" : "https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2FMonty%20Bar-D22A6E66-205A-49E1-B19F-AF9915CEE993-10.jpg",
            "has_thumb?" : 1,
            "tags" : ["pudding"],
            "created_at" : 1384327059.33636,
            "asset_ids": [1370368848]
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [],
            "created_at" : 0,
            "asset_ids": []
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "created_at" : 0,
            "has_thumb?" : 1,
            "asset_ids": [],
            "tags" : [
              "cake"
            ],
            "created_at" : 1384327159.33636,
            "asset_ids": [1370368849]
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [],
            "created_at" : 1384327259.33636,
            "asset_ids": [1370368850]
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [],
            "created_at" : 0,
            "asset_ids": []
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [
              "cake"
            ],
            "created_at" : 0,
            "asset_ids": []
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [
              "cake"
            ],
            "created_at" : 0,
            "asset_ids": []
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [
              "cake"
            ],
            "created_at" : 0,
            "asset_ids": []
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [
              "cake"
            ],
            "created_at" : 0,
            "asset_ids": []
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [
              "cake"
            ],
            "created_at" : 0,
            "asset_ids": []
          },
          {
            "remote_url" : "https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2FMonty%20Bar-D22A6E66-205A-49E1-B19F-AF9915CEE993-10.jpg",
            "has_thumb?" : 1,
            "tags" : ["pudding"],
            "created_at" : 1384327059.33636,
            "asset_ids": []
          },
          {
            "remote_url" : "https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2FMonty%20Bar-D22A6E66-205A-49E1-B19F-AF9915CEE993-10.jpg",
            "has_thumb?" : 1,
            "tags" : ["pudding"],
            "created_at" : 1384327060.33636,
            "asset_ids": []
          },
          {
            "remote_url" : "https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2FMonty%20Bar-D22A6E66-205A-49E1-B19F-AF9915CEE993-10.jpg",
            "has_thumb?" : 1,
            "tags" : ["pudding"],
            "created_at" : 1384327061.33636,
            "asset_ids": []
          }
        ],
        "problem_url":"",
        "state":"Jiangxi",
        "street":"",
        "sub_administrative_area":"",
        "sub_locality":"Yuanzhou",
        "sub_thoroughfare":"",
        "url":"",
        "zip":"",
        "country_code":"CHN",
        "country":"CN",
        "region_id":"",
        "sales_rep_id":"",
        "visit_enthusiasm":5.00000,
        "visit_quality":5.00000
      }'
    end

    factory :visit_with_several_incomplete_assets do
      body '{
        "archived?":false,
       "user_token":"mhBGnQbAXQ9N335Jypcw",
       "retailer_id":"454545",
       "created_at":"2014-03-26 07:42:38 +0000",
       "comment":"apple hotel?[20741:880f] vImage decode failed, falling back to CG path.\nMar 26 15:42:29 My-Mac.local Retail Mapper[20741] <Error>: CGBitmapContextCreate: unsupported parameter combination: 5 integer bits/component; 16 bits/pixel; 3-component color space; kCGImageAlphaNoneSkipLast; 512 bytes/row.\n2014-03-26 15:42:29.310 Retail Mapper[20741:880f] vImage decode failed, falling back to CG path.\nMar 26 15:42:29 My-Mac.local Retail Mapper[20741] <Error>: CGBitmapContextCreate: unsupported parameter combination: 5 integer bits/component; 16 bits/pixel; 3-component color space; kCGImageAlphaNoneSkipLast; 512 bytes/row.\n2014-03-26 15:42:29.317 Retail Mapper[20741:880f] vImage decode failed, falling back to CG path.\n",
       "visit_token":"B0D3EA85-2A87-4F9D-8707-99F3CC29B37C-20741-0000605821F49D2E",
       "business_id":null,
       "city":"Yichun",
       "latitude":27.807359,
       "local_search_provider_id":"",
       "longitude":114.402601,
       "name":"Apple Hotel",
       "phone_number":"",
        "photos" : [
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : ["pudding"],
            "created_at" : 1384327059.33636,
            "asset_ids": [1370368848]
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [],
            "asset_ids": []
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "created_at" : 0,
            "has_thumb?" : 1,
            "asset_ids": [],
            "tags" : [
              "cake"
            ],
            "created_at" : 1384327159.33636,
            "asset_ids": [1370368849]
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [],
            "created_at" : 1384327259.33636,
            "asset_ids": [1370368850]
          },
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [],
            "created_at" : 0,
            "asset_ids": []
          }
        ],
        "problem_url":"",
       "state":"Jiangxi",
       "street":"",
       "sub_administrative_area":"",
       "sub_locality":"Yuanzhou",
       "sub_thoroughfare":"",
       "url":"",
       "zip":"",
       "country_code":"CHN",
       "country":"CN",
       "region_id":"",
       "sales_rep_id":"",
       "visit_enthusiasm":0,
       "visit_quality":0
      }'
    end

    factory :archived_visit do |variable|
      body '{
        "comment" : "",
        "retailer_info" : {
          "yelp_id" : "none",
          "local_search_provider_id" : "9902",
          "problem_url" : "https:\/\/gsp8-ssl.apple.com\/?businessid=10582173481701573620&sessionidhigh=5871550430919614369&sessionidlow=6287726308012262930&localsearchproviderid=9902&lng=-122.03&lat=37.3318&placeid=",
          "is_current_location?" : 0,
          "place_id" : "none",
          "number_of_reviews" : "none",
          "entry_points" : "none",
          "phone_number" : "+14089741010",
          "url" : "http:\/\/www.apple.com",
          "rating" : "none",
          "business_id" : "10582173481701573620",
          "number_of_ratings" : "none",
          "attributions" : "none",
          "latitude" : "37.331848",
          "longitude" : "-122.030296",
          "country" : "United States",
          "street" : "1 Infinite Loop",
          "zip" : "95014",
          "city" : "Cupertino",
          "country_code" : "us",
          "state" : "California",
          "ext_session_guid" : "none",
          "name" : "Apple, Inc.",
          "is_business?" : 1
        },
        "visit_token" : "61CB157B-4EEB-436D-AF7B-21E45048EB37-20029-00001C47930E422D",
        "visit_scale" : "0",
        "created_at" : 1379637505,
        "progress" : 0,
        "archived?" : 1,
        "agent_scale" : "0",
        "assets" : [
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tags" : [
              "pudding"
            ]
          }
        ],
        "user_token" : "Nc3MqibNELJpxc6qu9Tp"
      }'
    end

    factory :visit_without_zip do
      body '{
        "comment" : "",
        "retailer_info" : {
          "yelp_id" : "none",
          "local_search_provider_id" : "9902",
          "problem_url" : "https:\/\/gsp8-ssl.apple.com\/?businessid=10582173481701573620&sessionidhigh=5871550430919614369&sessionidlow=6287726308012262930&localsearchproviderid=9902&lng=-122.03&lat=37.3318&placeid=",
          "is_current_location?" : 0,
          "place_id" : "none",
          "number_of_reviews" : "none",
          "entry_points" : "none",
          "phone_number" : "+14089741010",
          "url" : "http:\/\/www.apple.com",
          "rating" : "none",
          "business_id" : "10582173481701573620",
          "number_of_ratings" : "none",
          "attributions" : "none",
          "latitude" : "37.331848",
          "longitude" : "-122.030296",
          "country" : "United States",
          "street" : "1 Infinite Loop",
          "city" : "Cupertino",
          "country_code" : "us",
          "state" : "California",
          "ext_session_guid" : "none",
          "name" : "Apple, Inc.",
          "is_business?" : 1
        },
        "visit_token" : "61CB157B-4EEB-436D-AF7B-21E45048EB37-20029-00001C47930E422D",
        "visit_scale" : "0",
        "created_at" : 1379637505,
        "progress" : 0,
        "archived?" : 0,
        "agent_scale" : "0",
        "assets" : [
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tag_array" : [
              "pudding"
            ]
          }
        ],
        "user_token" : "Nc3MqibNELJpxc6qu9Tp"
      }'
    end

    factory :visit_without_zip2 do
      body '{"temp":"0","user_token":"1UZGyQd15HrVpnR1NSdf","created_at":1370968507,"retailer_info":{"problem_url":"https://gsp8-ssl.apple.com/?businessid=7382669836071797741&sessionidhigh=9902839373757380486&sessionidlow=6219045906738377513&localsearchproviderid=9902&lng=67.0786&lat=24.9086&placeid=","business_id":"7382669836071797741","name":"Gilani Raillway Station","longitude":"67.078600","local_search_provider_id":"9902","country":"Pakistan","country_code":"pk","city":"Karachi","state":"Sindh","latitude":"24.908600","is_business?":1,"is_current_location?":0},"comment":"We have rail","assets":[{"remote_url":"https://s3.amazonaws.com/visits.retailmapper.com/1UZGyQd15HrVpnR1NSdf%2FGilani%20Raillway%20Station-6D663163-6E23-4422-AB9F-EA036743AF66-0.jpg","has_thumb?":0,"tag_array":[],"asset_id_array":[]}],"visit_token":"5F8F9BBD-DC21-4514-AB4E-1057F1D63239-139-000000071982980C","archived?":0,"retailer_id":"none"}'
    end

    factory :visit_with_nil_zip do
      body '{"temp":"0","user_token":"1UZGyQd15HrVpnR1NSdf","created_at":1370968507,"retailer_info":{"problem_url":"https://gsp8-ssl.apple.com/?businessid=7382669836071797741&sessionidhigh=9902839373757380486&sessionidlow=6219045906738377513&localsearchproviderid=9902&lng=67.0786&lat=24.9086&placeid=","business_id":"7382669836071797741","name":"Gilani Raillway Station","longitude":"67.078600","local_search_provider_id":"9902","country":"Pakistan","country_code":"pk","city":"Karachi","state":"Sindh","latitude":"24.908600","is_business?":1,"is_current_location?":0,"zip":"nil"},"comment":"We have rail","assets":[{"remote_url":"https://s3.amazonaws.com/visits.retailmapper.com/1UZGyQd15HrVpnR1NSdf%2FGilani%20Raillway%20Station-6D663163-6E23-4422-AB9F-EA036743AF66-0.jpg","has_thumb?":0,"tag_array":[],"asset_id_array":[]}],"visit_token":"5F8F9BBD-DC21-4514-AB4E-1057F1D63239-139-000000071982980C","archived?":0,"retailer_id":"none"}'
    end

    factory :visit_with_none_zip do
      body '{"temp":"0","user_token":"1UZGyQd15HrVpnR1NSdf","created_at":1370968507,"retailer_info":{"problem_url":"https://gsp8-ssl.apple.com/?businessid=7382669836071797741&sessionidhigh=9902839373757380486&sessionidlow=6219045906738377513&localsearchproviderid=9902&lng=67.0786&lat=24.9086&placeid=","business_id":"7382669836071797741","name":"Gilani Raillway Station","longitude":"67.078600","local_search_provider_id":"9902","country":"Pakistan","country_code":"pk","city":"Karachi","state":"Sindh","latitude":"24.908600","is_business?":1,"is_current_location?":0,"zip":"none"},"comment":"We have rail","assets":[{"remote_url":"https://s3.amazonaws.com/visits.retailmapper.com/1UZGyQd15HrVpnR1NSdf%2FGilani%20Raillway%20Station-6D663163-6E23-4422-AB9F-EA036743AF66-0.jpg","has_thumb?":0,"tag_array":[],"asset_id_array":[]}],"visit_token":"5F8F9BBD-DC21-4514-AB4E-1057F1D63239-139-000000071982980C","archived?":0,"retailer_id":"none"}'
    end

    factory :visit_without_city do
      body '{
        "comment" : "",
        "retailer_info" : {
          "yelp_id" : "none",
          "local_search_provider_id" : "9902",
          "problem_url" : "https:\/\/gsp8-ssl.apple.com\/?businessid=10582173481701573620&sessionidhigh=5871550430919614369&sessionidlow=6287726308012262930&localsearchproviderid=9902&lng=-122.03&lat=37.3318&placeid=",
          "is_current_location?" : 0,
          "place_id" : "none",
          "number_of_reviews" : "none",
          "entry_points" : "none",
          "phone_number" : "+14089741010",
          "url" : "http:\/\/www.apple.com",
          "rating" : "none",
          "business_id" : "10582173481701573620",
          "number_of_ratings" : "none",
          "attributions" : "none",
          "latitude" : "37.331848",
          "longitude" : "-122.030296",
          "country" : "United States",
          "street" : "1 Infinite Loop",
          "zip" : "95014",
          "country_code" : "us",
          "state" : "California",
          "ext_session_guid" : "none",
          "name" : "Apple, Inc.",
          "is_business?" : 1
        },
        "visit_token" : "61CB157B-4EEB-436D-AF7B-21E45048EB37-20029-00001C47930E422D",
        "visit_scale" : "0",
        "created_at" : 1379637505,
        "progress" : 0,
        "archived?" : 0,
        "agent_scale" : "0",
        "assets" : [
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tag_array" : [
              "pudding"
            ]
          }
        ],
        "user_token" : "Nc3MqibNELJpxc6qu9Tp"
      }'
    end

    factory :visit_without_agent_scale_and_visit_scale do
      body '{
        "comment" : "",
        "retailer_info" : {
          "yelp_id" : "none",
          "local_search_provider_id" : "9902",
          "problem_url" : "https:\/\/gsp8-ssl.apple.com\/?businessid=10582173481701573620&sessionidhigh=5871550430919614369&sessionidlow=6287726308012262930&localsearchproviderid=9902&lng=-122.03&lat=37.3318&placeid=",
          "is_current_location?" : 0,
          "place_id" : "none",
          "number_of_reviews" : "none",
          "entry_points" : "none",
          "phone_number" : "+14089741010",
          "url" : "http:\/\/www.apple.com",
          "rating" : "none",
          "business_id" : "10582173481701573620",
          "number_of_ratings" : "none",
          "attributions" : "none",
          "latitude" : "37.331848",
          "longitude" : "-122.030296",
          "country" : "United States",
          "street" : "1 Infinite Loop",
          "zip" : "95014",
          "country_code" : "us",
          "state" : "California",
          "ext_session_guid" : "none",
          "name" : "Apple, Inc.",
          "is_business?" : 1
        },
        "visit_token" : "61CB157B-4EEB-436D-AF7B-21E45048EB37-20029-00001C47930E422D",
        "created_at" : 1379637505,
        "progress" : 0,
        "archived?" : 0,
        "assets" : [
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tag_array" : [
              "pudding"
            ]
          }
        ],
        "user_token" : "Nc3MqibNELJpxc6qu9Tp"
      }'
    end

    factory :visit_with_unknown_agent_and_visit_scale do
      body '{
        "comment" : "",
        "retailer_info" : {
          "yelp_id" : "none",
          "local_search_provider_id" : "9902",
          "problem_url" : "https:\/\/gsp8-ssl.apple.com\/?businessid=10582173481701573620&sessionidhigh=5871550430919614369&sessionidlow=6287726308012262930&localsearchproviderid=9902&lng=-122.03&lat=37.3318&placeid=",
          "is_current_location?" : 0,
          "place_id" : "none",
          "number_of_reviews" : "none",
          "entry_points" : "none",
          "phone_number" : "+14089741010",
          "url" : "http:\/\/www.apple.com",
          "rating" : "none",
          "business_id" : "10582173481701573620",
          "number_of_ratings" : "none",
          "attributions" : "none",
          "latitude" : "37.331848",
          "longitude" : "-122.030296",
          "country" : "United States",
          "street" : "1 Infinite Loop",
          "zip" : "95014",
          "city" : "Cupertino",
          "country_code" : "us",
          "state" : "California",
          "ext_session_guid" : "none",
          "name" : "Apple, Inc.",
          "is_business?" : 1
        },
        "visit_token" : "61CB157B-4EEB-436D-AF7B-21E45048EB37-20029-00001C47930E422D",
        "visit_scale" : "???",
        "created_at" : 1379637505,
        "progress" : 0,
        "archived?" : 0,
        "agent_scale" : "???",
        "assets" : [
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 1,
            "tag_array" : [
              "pudding"
            ]
          }
        ],
        "user_token" : "Nc3MqibNELJpxc6qu9Tp"
      }'
    end

    factory :visit_asset_no_thumb do
      body '{
        "archived?":false,
       "user_token":"mhBGnQbAXQ9N335Jypcw",
       "retailer_id":"454545",
       "created_at":"2014-03-26 07:42:38 +0000",
       "comment":"apple hotel?[20741:880f] vImage decode failed, falling back to CG path.\nMar 26 15:42:29 My-Mac.local Retail Mapper[20741] <Error>: CGBitmapContextCreate: unsupported parameter combination: 5 integer bits/component; 16 bits/pixel; 3-component color space; kCGImageAlphaNoneSkipLast; 512 bytes/row.\n2014-03-26 15:42:29.310 Retail Mapper[20741:880f] vImage decode failed, falling back to CG path.\nMar 26 15:42:29 My-Mac.local Retail Mapper[20741] <Error>: CGBitmapContextCreate: unsupported parameter combination: 5 integer bits/component; 16 bits/pixel; 3-component color space; kCGImageAlphaNoneSkipLast; 512 bytes/row.\n2014-03-26 15:42:29.317 Retail Mapper[20741:880f] vImage decode failed, falling back to CG path.\n",
       "visit_token":"B0D3EA85-2A87-4F9D-8707-99F3CC29B37C-20741-0000605821F49D2E",
       "business_id":null,
       "city":"Yichun",
       "latitude":27.807359,
       "local_search_provider_id":"",
       "longitude":114.402601,
       "name":"Apple Hotel",
       "phone_number":"",
        "photos" : [
          {
            "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
            "has_thumb?" : 0,
            "tags" : [
              "pudding"
            ]
          }
        ],
        "problem_url":"",
       "state":"Jiangxi",
       "street":"",
       "sub_administrative_area":"",
       "sub_locality":"Yuanzhou",
       "sub_thoroughfare":"",
       "url":"",
       "zip":"",
       "country_code":"CHN",
       "country":"CN",
       "region_id":"",
       "sales_rep_id":"",
       "visit_enthusiasm":0,
       "visit_quality":0
      }'
    end

    factory :visit_with_old_asset_structure do
      body '{
        "comment" : "",
        "retailer_info" : {
          "yelp_id" : "none",
          "local_search_provider_id" : "9902",
          "problem_url" : "https:\/\/gsp8-ssl.apple.com\/?businessid=10582173481701573620&sessionidhigh=5871550430919614369&sessionidlow=6287726308012262930&localsearchproviderid=9902&lng=-122.03&lat=37.3318&placeid=",
          "is_current_location?" : 0,
          "place_id" : "none",
          "number_of_reviews" : "none",
          "entry_points" : "none",
          "phone_number" : "+14089741010",
          "url" : "http:\/\/www.apple.com",
          "rating" : "none",
          "business_id" : "10582173481701573620",
          "number_of_ratings" : "none",
          "attributions" : "none",
          "latitude" : "37.331848",
          "longitude" : "-122.030296",
          "country" : "United States",
          "street" : "1 Infinite Loop",
          "zip" : "95014",
          "city" : "Cupertino",
          "country_code" : "us",
          "state" : "California",
          "ext_session_guid" : "none",
          "name" : "Apple, Inc.",
          "is_business?" : 1
        },
        "visit_token" : "61CB157B-4EEB-436D-AF7B-21E45048EB37-20029-00001C47930E422D",
        "visit_scale" : "0",
        "created_at" : 1379637505,
        "progress" : 0,
        "archived?" : 0,
        "agent_scale" : "0",
        "assets" : [
          "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg"
        ],
        "user_token" : "Nc3MqibNELJpxc6qu9Tp"
      }'
      # created_at: "Fri, 20 Sep 2013 00:38:25 +0000" / week : 37
    end

    factory :empty_visit_to_customize do
      body '{}'
      asset_id_array "{}"
    end

    factory :json_simplified_visit do
      body { generate(:retailerInfo) }
      title { generate(:title) }
    end

    factory :json_simplified_visit_archived do
      body { generate(:archived_retailerInfo) }
      archived_status true
    end

    factory :json_simplified_visit_not_archived do
      body { generate(:not_archived_retailerInfo) }
    end

    factory :json_simplified_visit_not_archived2 do
      body { generate(:not_archived_retailerInfo2) }
    end

    factory :json_simplified_visit_with_empty_assetsArray do
      body { generate(:retailerinfo_with_empty_assetsArray) }
    end

    factory :json_simplified_visit_noAssets do
      body { generate(:retailerInfo_with_noAssets) }
    end

    factory :json_simplified_visit_noAssets2 do
      body { generate(:retailerInfo_with_noAssets2) }
    end

    factory :json_simplified_visit_yearly do
      body { generate(:retailerInfo_with_asset_yearly) }
    end

    factory :json_simplified_visit_nil_created_at do
      body { generate(:not_archived_nil_created_at) }
    end

    factory :json_old_visit do
      body "{\"visit_scale\":\"1\",\"archived?\":0,\"progress\":null,\"user_token\":\"PDE1CytcR1JdzGpKDtwS\",\"retailer_id\":null,\"created_at\":1380210288,\"comment\":\"DNP, MNR, MM. Asian\",\"assets\":[{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FLiquor%20Plus-BFC76D59-C90C-4E76-99C3-8131FC7E4F90-4.jpg\",\"asset_id_array\":[],\"created_at\":1352849537},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FLiquor%20Plus-5FB869FF-6328-4090-B00D-0F8AAA7569D6-3.jpg\",\"asset_id_array\":[],\"created_at\":1352849537},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FLiquor%20Plus-E23DB92B-F15F-4E65-ABED-5385C6429A3B-5.jpg\",\"asset_id_array\":[],\"created_at\":1352849537},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FLiquor%20Plus-250C63FB-69F9-40C1-B718-9AF34115C0D9-2.jpg\",\"asset_id_array\":[],\"created_at\":1352849537},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FLiquor%20Plus-91634C8B-7804-43E2-B61F-969E2C890776-0.jpg\",\"asset_id_array\":[],\"created_at\":1352849537},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FLiquor%20Plus-BFF5C356-C579-4623-B7BF-0B6EC66CC459-1.jpg\",\"asset_id_array\":[],\"created_at\":1352849537}],\"visit_token\":\"4BCBBE09-7BF8-47FD-9466-14A63F8BDF08-4570-000002A2CF6C6AD2\",\"retailer_info\":{\"place_id\":\"none\",\"city\":\"Monterey Park\",\"zip\":\"91755\",\"url\":\"none\",\"country_code\":\"United States\",\"yelp_id\":\"none\",\"state\":\"California\",\"attributions\":\"none\",\"sub_thoroughfare\":\"431\",\"name\":\"Liquor Plus\",\"is_current_location?\":0,\"is_business?\":0,\"latitude\":\"34.062876\",\"street\":\"431 East Garvey Avenue\",\"local_search_provider_id\":\"none\",\"rating\":\"none\",\"longitude\":\"-118.115997\",\"number_of_reviews\":\"none\",\"number_of_ratings\":\"none\",\"phone_number\":\"+16265739508\",\"entry_points\":\"none\",\"country\":\"us\",\"sub_administrative_area\":\"Los Angeles\",\"problem_url\":\"none\",\"sub_locality\":\"none\",\"business_id\":\"none\",\"ext_session_guid\":\"none\"},\"agent_scale\":\"1\"}"
    end

    factory :potentially_crashing_visit do
      body  "{\"visit_scale\":\"1\",\"archived?\":0,\"progress\":null,\"user_token\":\"PDE1CytcR1JdzGpKDtwS\",\"retailer_id\":null,\"created_at\":1380210288,\"comment\":\"DNP, MNR, MM. Asian\",\"assets\":[{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FMike%27s%20Liquor-EA2B8569-A695-4C76-8EE1-09C5280F7A5C-0.jpg\",\"asset_id_array\":[],\"created_at\":1352849754},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FMike%27s%20Liquor-CD7DFA54-50D7-44AC-BBFF-64D2A5050EA8-1.jpg\",\"asset_id_array\":[],\"created_at\":1352849754},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FMike%27s%20Liquor-F9170730-1760-4BA1-888A-13756BE28007-2.jpg\",\"asset_id_array\":[],\"created_at\":1352849754},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FMike%27s%20Liquor-6068CE73-54D7-4966-A368-48D589DC6B20-3.jpg\",\"asset_id_array\":[],\"created_at\":1352849754},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FMike%27s%20Liquor-D0DD5CE0-4F64-4A88-828E-0D455DCBB16D-4.jpg\",\"asset_id_array\":[],\"created_at\":1352849754},{\"has_thumb?\":1,\"tag_array\":[\"Far Right Window\"],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FMike%27s%20Liquor-846B551A-752C-4717-B980-19474D605FB8-5.jpg\",\"asset_id_array\":[],\"created_at\":1352849754},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FMike%27s%20Liquor-B71921DF-308A-402B-9DE8-97D0DDE71BFF-6.jpg\",\"asset_id_array\":[],\"created_at\":1352849754},{\"has_thumb?\":1,\"tag_array\":[\"Far Right Window\"],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2FMike%27s%20Liquor-D0C64AC9-30D9-4667-926A-2BE1E6A4A720-7.jpg\",\"asset_id_array\":[],\"created_at\":1352849754}],\"visit_token\":\"4BCBBE09-7BF8-47FD-9466-14A63F8BDF08-4570-000002A2CF6C6AD2\",\"retailer_info\":{\"place_id\":\"none\",\"city\":\"Monterey Park\",\"zip\":\"91755\",\"url\":\"none\",\"country_code\":\"United States\",\"yelp_id\":\"none\",\"state\":\"California\",\"attributions\":\"none\",\"sub_thoroughfare\":\"431\",\"name\":\"Liquor Plus\",\"is_current_location?\":0,\"is_business?\":0,\"latitude\":\"34.062876\",\"street\":\"431 East Garvey Avenue\",\"local_search_provider_id\":\"none\",\"rating\":\"none\",\"longitude\":\"-118.115997\",\"number_of_reviews\":\"none\",\"number_of_ratings\":\"none\",\"phone_number\":\"+16265739508\",\"entry_points\":\"none\",\"country\":\"us\",\"sub_administrative_area\":\"Los Angeles\",\"problem_url\":\"none\",\"sub_locality\":\"none\",\"business_id\":\"none\",\"ext_session_guid\":\"none\"},\"agent_scale\":\"1\"}"
    end

    factory :potentially_crashing_visit2 do
      body "{\"visit_scale\":\"1\",\"archived?\":0,\"progress\":null,\"user_token\":\"PDE1CytcR1JdzGpKDtwS\",\"retailer_id\":null,\"created_at\":1380210288,\"comment\":\"DNP, MNR, MM. Asian\",\"assets\":[{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-67219A31-2C51-478B-BB7D-8EA06EDA50F9-0.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-57EB1CBF-26E0-438A-A744-B8217741A044-1.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-11D77F76-4FC0-4E96-8EB1-E740089AAD95-2.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-EE293C57-13B2-42C6-873B-F499ED733232-3.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-417F2B19-B4FE-4620-B589-B345CB9530C9-5.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-5D2137E1-33E3-4BE3-B0E7-EE1BC5761C54-4.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-F60CB4D0-6C4C-4DF5-980E-2AA173EA520E-6.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-58BA402A-45A5-4A05-A246-F1C4E9395769-7.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-B474EDE3-C2D0-45C9-ACF3-2C6B0ABED118-9.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-4C302404-89B9-41D8-B194-E85BF99636B1-8.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-B022F374-585E-4E20-B6E0-1041D5D46915-10.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-E541DEFB-AE9C-48DA-8E14-68FE0E9BB47B-11.jpg\",\"asset_id_array\":[],\"created_at\":1352849551},{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F8205%20Hellman%20Ave-950F90BA-C20E-47D3-ADF8-9CDC04ABEDE7-12.jpg\",\"asset_id_array\":[],\"created_at\":1352849551}],\"visit_token\":\"4BCBBE09-7BF8-47FD-9466-14A63F8BDF08-4570-000002A2CF6C6AD2\",\"retailer_info\":{\"place_id\":\"none\",\"city\":\"Monterey Park\",\"zip\":\"91755\",\"url\":\"none\",\"country_code\":\"United States\",\"yelp_id\":\"none\",\"state\":\"California\",\"attributions\":\"none\",\"sub_thoroughfare\":\"431\",\"name\":\"Liquor Plus\",\"is_current_location?\":0,\"is_business?\":0,\"latitude\":\"34.062876\",\"street\":\"431 East Garvey Avenue\",\"local_search_provider_id\":\"none\",\"rating\":\"none\",\"longitude\":\"-118.115997\",\"number_of_reviews\":\"none\",\"number_of_ratings\":\"none\",\"phone_number\":\"+16265739508\",\"entry_points\":\"none\",\"country\":\"us\",\"sub_administrative_area\":\"Los Angeles\",\"problem_url\":\"none\",\"sub_locality\":\"none\",\"business_id\":\"none\",\"ext_session_guid\":\"none\"},\"agent_scale\":\"1\"}"
    end

    factory :visit_with_panorama_assets do
      body "{\"visit_scale\":\"1\",\"archived?\":0,\"progress\":null,\"user_token\":\"PDE1CytcR1JdzGpKDtwS\",\"retailer_id\":null,\"created_at\":1380210288,\"comment\":\"DNP, MNR, MM. Asian\",\"assets\":[{\"has_thumb?\":1,\"tag_array\":[],\"remote_url\":\"https://s3.amazonaws.com/visits.retailmapper.com/PDE1CytcR1JdzGpKDtwS%2F2101%20Wayne%20Memorial%20Dr-1E83C21F-81F3-4297-A15D-AA54A1B739C7-4.jpg\",\"asset_id_array\":[],\"created_at\":1352849551}],\"visit_token\":\"4BCBBE09-7BF8-47FD-9466-14A63F8BDF08-4570-000002A2CF6C6AD2\",\"retailer_info\":{\"place_id\":\"none\",\"city\":\"Monterey Park\",\"zip\":\"91755\",\"url\":\"none\",\"country_code\":\"United States\",\"yelp_id\":\"none\",\"state\":\"California\",\"attributions\":\"none\",\"sub_thoroughfare\":\"431\",\"name\":\"Liquor Plus\",\"is_current_location?\":0,\"is_business?\":0,\"latitude\":\"34.062876\",\"street\":\"431 East Garvey Avenue\",\"local_search_provider_id\":\"none\",\"rating\":\"none\",\"longitude\":\"-118.115997\",\"number_of_reviews\":\"none\",\"number_of_ratings\":\"none\",\"phone_number\":\"+16265739508\",\"entry_points\":\"none\",\"country\":\"us\",\"sub_administrative_area\":\"Los Angeles\",\"problem_url\":\"none\",\"sub_locality\":\"none\",\"business_id\":\"none\",\"ext_session_guid\":\"none\"},\"agent_scale\":\"1\"}"
    end
  end

end