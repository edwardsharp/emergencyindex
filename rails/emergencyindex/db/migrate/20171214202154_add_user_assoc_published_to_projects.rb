class AddUserAssocPublishedToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :user_id, :string
    add_column :projects, :published, :boolean, default: false
  end
end
