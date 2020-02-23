require 'httparty'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# binding.pry

# Get parks from National Park Service api
response = HTTParty.get("https://developer.nps.gov/api/v1/parks?limit=1000&api_key=#{ENV['NPS_API_KEY']}", format: :plain)
parsed = JSON.parse response, symbolize_names: true

# Create park objects from api response
parsed[:data].each do |park| 
  Park.create(
    npsId: park[:id],
    latLong: park[:latLong],
    description: park[:description],
    designation: park[:designation],
    parkCode: park[:parkCode],
    fullName: park[:fullName],
    url: park[:url]
  )
end