class CreateProjects < ActiveRecord::Migration[5.1]
  def up
    create_table :projects, id: :string do |t|
      t.string :user_id
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
      
      t.boolean :published, default: false
      t.string :published_by

      t.timestamps null: false
    end

    execute <<-SQL
      CREATE TRIGGER trigger_test_genid BEFORE INSERT ON projects FOR EACH ROW EXECUTE PROCEDURE unique_short_id();
    SQL

    add_index :projects, :created_at
  end

  def down
    drop_table :projects
  end
end
