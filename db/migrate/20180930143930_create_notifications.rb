class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer :idUser
      t.integer :idContent
      t.datetime :created_at
      t.boolean :isNews
      t.boolean :isReports
      t.boolean :isEvents
      t.string :titleContent
      t.boolean :seen

      t.timestamps
    end
  end
end
