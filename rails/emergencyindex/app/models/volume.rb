class Volume < ApplicationRecord
  has_many :projects
  validates_uniqueness_of :year
end
