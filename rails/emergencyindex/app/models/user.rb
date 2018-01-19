class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email?")
    end
  end
end


class User < ApplicationRecord
  has_many :projects

  validates :name, length: { minimum: 3 }
  validates :email, presence: true, email: true

  validates :phone, presence: true

  # Include default devise modules. Others available are:  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  acts_as_tagger
  
end
