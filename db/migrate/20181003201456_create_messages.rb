class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :id_chat
      t.integer :id_user
      t.string :message
      t.boolean :seen

      t.timestamps
    end
  end
end
