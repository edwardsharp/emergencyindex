class Project < ApplicationRecord

  belongs_to :user
  
  default_scope { order(created_at: :desc) }
  
  validates :title, :first_date, :location, :dates, :artist_name, 
    :home, :contact, :links, :description, presence: true

  has_attached_file :attachment, styles: { medium: "600x600>", thumb: "100x100>" } #, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\z/

  validate :project_description
  validate :image_dimensions

  private
  def project_description
    if description.scan(/\w+/).length > 400
      errors.add(:description,  "Please limit your description to less than 400 words")
    end
  end

  def image_dimensions
    temp_file = attachment.queued_for_write[:original]
    unless temp_file.nil?
      d = Paperclip::Geometry.from_file(temp_file)
      # p "\nimage_dimensions d.width: #{d.width} d.height: #{d.height} class: #{d.height.class}\n\n\n"
      if (d.width != 1500 and d.width != 2100) or (d.height != 1500 and d.height != 2100)
        errors.add(:attachment, "Image needs to be 5x7 inches (or 1500x2100 pixels).")
      end
    end
  end

end
