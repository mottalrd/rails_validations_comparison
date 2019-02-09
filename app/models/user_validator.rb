class UserValidator < ActiveModel::Validator
  include ErrorsHelper

  EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  UserSchema = Dry::Validation.Schema do
    configure do
      config.messages_file = 'config/user_errors.yml'

      def unique?(email)
        User.find_by(email: email).nil?
      end
    end

    required(:email) { format?(EMAIL_REGEX) & unique? }
    required(:marketing_opt_in).bool?
    required(:age) { filled? & int? & gteq?(18) }
  end

  def validate(record)
    outcome = UserSchema.call(record.attributes.symbolize_keys)

    add_errors(from: outcome, to: record)
  end
end

