class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class Project < ApplicationRecord

  validates :name, length: { minimum: 3 }
  validates :email, presence: true, email: true

  validates :phone, :title, :first_date, :location, :dates, :artist_name, 
    :collaborators, :home, :contact, :links, :description, presence: true

  has_attached_file :attachment, styles: { medium: "300x300>", thumb: "100x100>" } #, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\z/

end
