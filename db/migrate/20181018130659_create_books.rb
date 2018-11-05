class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name
      t.text :intro
      t.integer :user_id

      t.timestamps
    end
  end
end
