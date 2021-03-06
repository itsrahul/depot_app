class ImageUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\.(gif|jpg|png)\z/i
      record.errors[attribute] << (options[:message] || "must be a URL for GIF, JPG or PNG image.")
    end
  end
end