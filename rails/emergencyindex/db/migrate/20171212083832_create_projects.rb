class CreateProjects < ActiveRecord::Migration[5.1]
  def up
    create_table :projects, id: :string do |t|
      
      t.string :contact_name
      t.string :contact_email
      t.string :contact_postal
      t.string :contact_phone

      t.string :title
      t.string :name
      t.boolean :already_submitted
      t.string :collaborators
      t.string :first_date
      t.integer :times_performed, default: 1
      t.string :venue
      t.string :city
      t.string :state_country
      t.string :home
      t.string :published_contact
      t.string :links
      t.string :description
      t.boolean :description_monospace
      t.string :footnote
      t.string :photo_credit
      
      t.boolean :published, default: false
      t.string :published_by

      t.jsonb :original_scrape, null: false, default: {}
      t.index :original_scrape, using: :gin

      t.timestamps null: false
      t.string :user_id

    end

    execute <<-SQL
      CREATE TRIGGER trigger_test_genid BEFORE INSERT ON projects FOR EACH ROW EXECUTE PROCEDURE unique_short_id();
    SQL

    add_index :projects, :created_at
    add_index :projects, :first_date
  end

  def down
    drop_table :projects
  end
end
