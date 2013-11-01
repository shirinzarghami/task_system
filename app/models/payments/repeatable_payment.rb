class RepeatablePayment < Payment
  has_one :repeatable_item, as: :repeatable, dependent: :destroy

  accepts_nested_attributes_for :repeatable_item

  def repeat
    
  end
end