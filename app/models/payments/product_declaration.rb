class ProductDeclaration < Payment
  validate :result_is_zero

  # protected
    def result_is_zero
      netto = self.user_saldo_modifications.sum(&:price)
      max_deviation = 1.to_f / (10**CONFIG[:price_precision])
      deviation_within_limits = (netto < max_deviation && netto > -max_deviation) 
      errors.add(:base, :result_should_be_zero) unless deviation_within_limits
    end
end