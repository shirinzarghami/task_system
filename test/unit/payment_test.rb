require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  setup do
    @community = FactoryGirl.create :community_with_users
    @payer = @community.community_users.first
  end
  context "product declaration" do
    should "save when sum of user modifications is 0" do
      @payment = FactoryGirl.create(:product_declaration_with_saldos, 
        price: 100, 
        community_user: @payer, 
        saldo_price_1: 75,
        community_users_set_1: [@community.community_users.first],
        saldo_price_2: -25,
        community_users_set_2: @community.community_users.last(3)
        )
      assert @payment.reload && @payment.save      
    end

    should "not save when sum is not 0" do
      @payment = FactoryGirl.create(:product_declaration_with_saldos, 
        price: 100, 
        community_user: @payer, 
        saldo_price_1: 100,
        community_users_set_1: [@community.community_users.first],
        saldo_price_2: -25,
        community_users_set_2: @community.community_users.last(3)
        )
      assert @payment.reload && !@payment.save    

    end
  end
end
