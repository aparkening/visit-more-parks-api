class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :park, index: true, foreign_key: true

      t.string :title
      t.string :location
      t.string :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :timezone
      t.string :g_cal_id

      t.timestamps
    end
  end
end
