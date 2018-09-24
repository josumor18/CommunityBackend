class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :id_comment
      t.integer :id_user
      t.string :reason

      t.timestamps
    end
  end
end
