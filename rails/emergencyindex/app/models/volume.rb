class Volume < ApplicationRecord
  has_many :projects
  validates_uniqueness_of :year
  validates_uniqueness_of :name
  default_scope { order(year: :asc, name: :asc) }
  
  scope :official, -> { where(official: true) } 
  
  # ransacker :year do
  #   Arel.sql("to_char(year, '9999999')")
  # end

  # def open_date
  #   Time.strptime(open_date_string, '%Y/%m/%d')
  # end
  # def close_date
  #   Time.strptime(close_date_string, '%Y/%m/%d')
  # end

end
