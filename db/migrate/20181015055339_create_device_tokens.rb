class CreateDeviceTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :device_tokens do |t|
      t.integer :id_user
      t.string :token

      t.timestamps
    end
  end
end
