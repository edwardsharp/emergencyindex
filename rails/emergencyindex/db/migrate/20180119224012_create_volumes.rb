class CreateVolumes < ActiveRecord::Migration[5.1]
  def up
    create_table :volumes, id: :string do |t|

      t.integer :year
      t.string :name
      t.string :open_date_string
      t.string :close_date_string

      t.timestamps
    end

    execute <<-SQL
      CREATE TRIGGER trigger_test_genid BEFORE INSERT ON volumes FOR EACH ROW EXECUTE PROCEDURE unique_short_id();
    SQL

    add_index :volumes, :year, unique: true
    add_index :volumes, :name, unique: true
    add_column :projects, :volume_id, :string
  end

  def down
    drop_table :volumes
    remove_column :projects, :volume_id
  end

end
