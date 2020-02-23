class CreateParks < ActiveRecord::Migration[6.0]
  def change
    create_table :parks do |t|
      t.string :npsId
      t.string :latLong
      t.string :description
      t.string :designation
      t.string :parkCode
      t.string :fullName
      t.string :url

      t.timestamps
    end
  end
end
