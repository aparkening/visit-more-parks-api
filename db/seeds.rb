require 'httparty'

# binding.pry

# Get parks from National Park Service API
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