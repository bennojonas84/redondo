module JsonDatas

  def photos_json
    '[
      {
        "remote_url":"https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2F48506C75-4E8F-4F9E-A594-66582EDFD405-0.jpg",
        "created_at":"2014-03-26 07:43:06 +0000",
        "has_thumb?":true,
        "asset_ids":[],
        "tags":["pudding"]
      },
      {
        "remote_url" : "https:\/\/s3.amazonaws.com\/visits.retailmapper.com\/Nc3MqibNELJpxc6qu9Tp%2FApple%2C%20Inc.-0E1DD443-51B2-4C24-B8D3-9069AF150D57-0.jpg",
        "has_thumb?" : 1,
        "tags" : [],
        "asset_ids": []
      },
      {
        "remote_url":"https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2F2A35E52F-ACCA-4D75-944D-E4AA6469D2C0-1.jpg",
        "created_at":"2014-03-26 07:43:06 +0000",
        "has_thumb?":true,
        "asset_ids":[1370368850],
        "tags":["cake"]
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
    ]'
  end

  def self.latest_visit_json
    '{
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
       "photos":[
          {
             "remote_url":"https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2F48506C75-4E8F-4F9E-A594-66582EDFD405-0.jpg",
             "created_at":"2014-03-26 07:43:06 +0000",
             "has_thumb?":true,
             "asset_ids":[1369253809, 1373045015, 1370368869],
             "tags":["pudding"]
          },
          {
             "remote_url":"https://s3.amazonaws.com/visits.retailmapper.com/mhBGnQbAXQ9N335Jypcw%2F2A35E52F-ACCA-4D75-944D-E4AA6469D2C0-1.jpg",
             "created_at":"2014-03-26 07:43:06 +0000",
             "has_thumb?":true,
             "asset_ids":[1370368869, 1370368848],
             "tags":[]
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
end

if Object.const_defined?('RSpec')
  RSpec.configure do |config|
    config.include JsonDatas
  end  
end

class Factory
  include JsonDatas
end