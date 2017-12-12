class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :title
      t.string :first_date
      t.string :location
      t.string :dates
      t.string :artist_name
      t.string :collaborators
      t.string :home
      t.string :contact
      t.string :links
      t.string :description
      t.string :image_href

      t.timestamps
    end
  end
end
