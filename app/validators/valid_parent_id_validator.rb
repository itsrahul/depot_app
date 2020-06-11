class ValidParentIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Category.root.exists?(value)
      record.errors[attribute] << (options[:message] || "is invalid")
    end
  end
end