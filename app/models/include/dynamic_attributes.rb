module DynamicAttributes
  def evaluate_dynamic_attributes
    self.dynamic_attributes = self.class::PERSIST_DYNAMIC_ATTRIBUTES.inject({}) do |dynamic_attribute_values, attribute|
      dynamic_attribute_values.merge! attribute => self.send(attribute)
    end
  end
  def populate_dynamic_attributes
    (self.dynamic_attributes || {}).each do |attribute, value|
      self.send "#{attribute}=", value
    end
  end

  def self.included object
    super
    object.after_find  :populate_dynamic_attributes         
    object.before_save :evaluate_dynamic_attributes     
    object.serialize :dynamic_attribute_values
  end
end