class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.int :idCommunity
      t.string :title
      t.string :description
      t.datetime :date
      t.string :photo
      t.boolean :approved

      t.timestamps
    end
  end
end
