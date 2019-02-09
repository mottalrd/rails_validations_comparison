class Address < ApplicationRecord
  belongs_to :user

  validates_with AddressValidator
end
