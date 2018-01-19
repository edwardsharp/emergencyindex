class Project < ApplicationRecord

  belongs_to :user

  validates :title, :name, :first_date, :times_performed,
    :venue, :city, :state_country, :times_performed, :home, :description, 
    presence: true

  validates_inclusion_of :already_submitted, :in => [true, false]

  has_attached_file :attachment, styles: { thumb: ["100x100>", :jpg], medium: ["600x600>", :jpg], :large => ["100%", :jpg] }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('default.jpg') }
  
  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\z/

  validate :project_description
  validate :image_dimensions

  default_scope { order(created_at: :desc) }

  acts_as_taggable
  
  def word_count
    description.scan(/\w+/).length rescue 0
  end

  def first_date_text
    Time.strptime(first_date, '%Y/%m/%d').strftime('%B %e, %Y') rescue first_date
  end

  def times_performed_text
    if times_performed == 1
      'once'
    elsif times_performed == 2
      'twice'
    elsif times_performed > 2
      "#{times_performed.to_words} times"
    end 
  end

  private
  def project_description
    if word_count > 400
      errors.add(:description,  "needs to be less than 400 words (currently #{word_count} words).")
    end
  end

  def image_dimensions
    temp_file = attachment.queued_for_write[:original]
    unless temp_file.nil?
      d = Paperclip::Geometry.from_file(temp_file)
      if (d.width != 1500 and d.width != 2100) or (d.height != 1500 and d.height != 2100)
        errors.add(:attachment, "Image needs to be 5x7 inches (or 1500x2100 pixels).")
      end
    end
  end

end
