class FixTagIdTypes < ActiveRecord::Migration[5.1]
  def change
    change_column(:taggings, :taggable_id, :string)
    change_column(:taggings, :tagger_id, :string)
  end
end
