class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.integer :id_user
      t.integer :id_news

      t.timestamps
    end
  end
end
