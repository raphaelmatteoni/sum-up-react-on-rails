class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.references :bill, foreign_key: true
      t.timestamps
    end
  end
end
