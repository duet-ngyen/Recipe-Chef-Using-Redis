class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :summary

      t.timestamps null: false
    end
  end
end
