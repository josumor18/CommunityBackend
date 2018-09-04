class CreateCommunityMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :community_members do |t|
      t.integer :id_community
      t.integer :id_user
      t.boolean :isAdmin

      t.timestamps
    end
  end
end
