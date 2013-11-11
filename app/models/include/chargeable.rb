module Chargeable
  module Validations
    def result_is_zero sum
      max_deviation = 1.to_f / (10**CONFIG[:price_precision])
      deviation_within_limits = (sum.nil? || (sum < max_deviation && sum > -max_deviation))

      unless deviation_within_limits
        errors.add(:base, :result_should_be_zero)
        false
      end

    end
  end
end