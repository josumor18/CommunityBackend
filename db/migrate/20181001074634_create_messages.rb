class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :id_chat
      t.string :message
      t.boolean :sent

      t.timestamps
    end
  end
end
