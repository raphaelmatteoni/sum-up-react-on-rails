class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :value, precision: 10, scale: 2, null: false
      t.references :bill, foreign_key: true
      t.references :group, foreign_key: true, null: true
      t.timestamps
    end
  end
end
