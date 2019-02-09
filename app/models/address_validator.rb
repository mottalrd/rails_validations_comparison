class AddressValidator < ActiveModel::Validator
  include ErrorsHelper

  # https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom#Validation
  POSTCODE_REGEX = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/

  AddressSchema = Dry::Validation.Schema do
    configure do
      config.messages_file = 'config/user_errors.yml'

      def postcode_exists_in_remote_database?(postcode)
        response = Faraday.get(
          "http://api.postcodes.io/postcodes/#{postcode.gsub(' ', '')}"
        )

        response.status == 200
      end
    end

    required(:street) { filled? }
    required(:postcode) { format?(POSTCODE_REGEX) & postcode_exists_in_remote_database? }
  end

  def validate(record)
    outcome = AddressSchema.call(record.attributes.symbolize_keys)

    add_errors(from: outcome, to: record)
  end
end
