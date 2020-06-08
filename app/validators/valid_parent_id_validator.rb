class ValidParentIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Category.where("parent_id is null").pluck(:id).include?(value)
      record.errors[attribute] << (options[:message] || "is invalid")
    end
  end
end