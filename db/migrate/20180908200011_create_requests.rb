class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.integer :id_community
      t.integer :id_user

      t.timestamps
    end
  end
end
