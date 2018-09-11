class AddSeenToRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :seen, :boolean
  end
end
