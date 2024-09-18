class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.references :owner, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
