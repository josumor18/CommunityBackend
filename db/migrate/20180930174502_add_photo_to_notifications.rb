class AddPhotoToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :photo, :string
  end
end
