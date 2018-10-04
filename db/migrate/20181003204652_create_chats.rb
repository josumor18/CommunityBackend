class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.integer :id_community
      t.integer :id_user
      t.boolean :is_group

      t.timestamps
    end
  end
end
