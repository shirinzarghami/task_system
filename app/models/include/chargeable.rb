module Chargeable
  module Validations
    def result_is_zero sum
      max_deviation = 1.to_f / (10**CONFIG[:price_precision])
      deviation_within_limits = (sum < max_deviation && sum > -max_deviation) 
      errors.add(:base, :result_should_be_zero) unless deviation_within_limits
    end
  end
end