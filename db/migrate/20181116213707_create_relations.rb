class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.string :follower
      t.string :following
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
