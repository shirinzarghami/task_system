class ProductDeclaration < Payment

  validate :result_is_zero

  protected
    def result_is_zero
      netto = self.user_saldo_modifications.sum(&:price)
      deviation_to_large =  (netto < CONFIG[:price_precision] && netto > -CONFIG[:price_precision]) 
      errors.add(:base, :result_should_be_zero)
    end
end