class User < ApplicationRecord
  has_one :address

  EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  validates :marketing_opt_in, inclusion: { in: [ true, false ] } 
  validates :email, format: EMAIL_REGEX
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 18 }
  validate :email_is_unique

  accepts_nested_attributes_for :address

  def email_is_unique
    if User.find_by(email: email)
      errors.add(:email, "must be unique")
    end
  end
end
