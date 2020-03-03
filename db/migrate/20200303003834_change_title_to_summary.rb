class ChangeTitleToSummary < ActiveRecord::Migration[6.0]
  def change
    rename_column :events, :title, :summary
  end
end
