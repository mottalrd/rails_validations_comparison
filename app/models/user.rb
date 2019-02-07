class User < ApplicationRecord
  has_one :address

  validates_with UserValidator

  accepts_nested_attributes_for :address
end
