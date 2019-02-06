class Address < ApplicationRecord
  belongs_to :user

  # https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom#Validation
  POSTCODE_REGEX = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/

  validates :street, presence: true
  validates :postcode, format: POSTCODE_REGEX
  validate :postcode_exists_in_remote_database

  def postcode_exists_in_remote_database
    response = Faraday.get(
      "http://api.postcodes.io/postcodes/#{postcode.gsub(' ', '')}"
    )

    if response.status == '404'
      errors.add(:postcode, "can't be found")
    end
  end
end
