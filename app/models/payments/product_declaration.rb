class ProductDeclaration < Payment
  include Chargeable::Validations
  validate :result_is_zero
  
  def result_is_zero
    super self.user_saldo_modifications.map(&:price).inject {|sum, price| sum + price}
  end
end