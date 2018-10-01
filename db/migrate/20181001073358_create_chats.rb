class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.integer :id_community
      t.integer :id_receiver
      t.string :last_message
      t.boolean :visto

      t.timestamps
    end
  end
end
