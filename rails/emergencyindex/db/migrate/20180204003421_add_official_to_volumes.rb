class AddOfficialToVolumes < ActiveRecord::Migration[5.1]
  def change
    add_column :volumes, :official, :boolean, default: false
  end
end
