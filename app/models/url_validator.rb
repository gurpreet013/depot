class UrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "is not an url") unless
      value =~ /[A-Z]/i
  end

end
