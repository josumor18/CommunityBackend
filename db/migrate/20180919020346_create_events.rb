class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :id_community
      t.string :title
      t.string :description
      t.date :dateEvent
      t.time :start
      t.time :end
      t.string :photo
      t.boolean :approved

      t.timestamps
    end
  end
end
