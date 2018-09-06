class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.string :description
      t.string :rules
      t.boolean :isSubcommunity
      t.string :photo
      t.string :photo_thumbnail
      t.integer :sub_communities

      t.timestamps
    end
  end
end
