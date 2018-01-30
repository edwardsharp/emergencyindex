class AddSeeAlsoToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :see_also, :string
    add_column :tags, :alias, :string
  end
end
