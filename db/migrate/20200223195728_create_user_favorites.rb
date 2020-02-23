class CreateUserFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :user_favorites do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :park, index: true, foreign_key: true

      t.timestamps
    end
  end
end
