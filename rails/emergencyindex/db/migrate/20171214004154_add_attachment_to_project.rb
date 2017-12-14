class AddAttachmentToProject < ActiveRecord::Migration[5.1]
  def up
    add_attachment :projects, :attachment
  end

  def down
    remove_attachment :projects, :attachment
  end
end
