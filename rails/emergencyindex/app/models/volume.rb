class Volume < ApplicationRecord
  has_many :projects
  validates_uniqueness_of :year

  # ransacker :year do
  #   Arel.sql("to_char(year, '9999999')")
  # end
end
