class CreateParks < ActiveRecord::Migration[6.0]
  def change
    create_table :parks do |t|
      t.string :npsId
      t.string :latLong
      t.float :latitude
      t.float :longitude
      t.string :description
      t.string :designation
      t.string :parkCode
      t.string :fullName
      t.string :url
      t.string :address

      t.timestamps
    end
  end
end
