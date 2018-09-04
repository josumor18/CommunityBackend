class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :cel
      t.string :tel
      t.string :address
      t.string :photo
      t.string :photo_thumbnail
      t.boolean :isPrivate
      t.string :auth_token

      t.timestamps
    end
  end
end
