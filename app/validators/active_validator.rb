class ActiveValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value&.active?
      record.errors.add attribute, 'must be active'
    end
  end
end
