# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'net/http'
require 'uri'
require 'json'


def create_park_from_json json_url
  uri = URI.parse(json_url)
  json = Net::HTTP.get(uri)
  result = JSON.parse(json)

  result["result"]["records"].each do |row|
    begin
      # sleep(1)
      pp row
      match = row["供用日"].match(/(平成|昭和)(?<era>[0-9]+)年(?<month>[0-9]+)月(?<day>[0-9]+)日/)
      service_at =  Date.new(match["era"].to_i - 12 + 2000, match["month"].to_i, match["day"].to_i)

      Park.create(
        name: row["公園名"],
        address: "静岡県静岡市#{row['区名']}#{row['所在地']}",
        area_square: row["現行公園面積(㎡)"],
        area_hectare: row["現行公園面積(ha)"],
        service_at_str: row["供用日"],
        service_at: service_at
      )
    rescue => e
      pp e
      retry
    end
  end
end


[
  "http://dataset.city.shizuoka.jp/api/action/datastore_search?resource_id=83bba366-f187-4324-9d36-7d1320f1a0c2",
  "http://dataset.city.shizuoka.jp/api/action/datastore_search?resource_id=552872c2-4e89-483d-a8cf-849993c17d89"
].each do |data_url|
  create_park_from_json data_url
end

# 住所にスペースが入っていると位置情報が検出できないっぽいので排除する
Park.all.select{|r|r.address.match(/\s|\S/)}.each{|r|r.address.gsub!(" ", "");r.save!; }
