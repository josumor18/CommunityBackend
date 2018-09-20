class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :id_news
      t.integer :id_user
      t.string :description

      t.timestamps
    end
  end
end
