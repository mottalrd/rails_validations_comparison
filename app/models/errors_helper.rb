module ErrorsHelper
  def add_errors(from:, to:)
    from.errors.each do |key, messages|
      messages.each do |message|
        begin
          to.errors.add(key, :invalid, message: message)
        rescue NoMethodError
          to.errors.add(:base, :invalid, message: message)
        end
      end
    end
  end
end
