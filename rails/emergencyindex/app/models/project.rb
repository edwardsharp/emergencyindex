class Project < ApplicationRecord

  belongs_to :user
  
  default_scope { order(created_at: :desc) }
  
  validates :title, :first_date, :location, :dates, :artist_name, 
    :home, :contact, :links, :description, presence: true

  has_attached_file :attachment, styles: { medium: "300x300>", thumb: "100x100>" } #, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\z/

end
