require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  setup do
    @community = FactoryGirl.create :community_with_users
    @payer = @community.community_users.first
  end
  context "product declaration" do
    # should "save when sum of user modifications is 0" do
    #   debugger  
    #   @payment = FactoryGirl.create :product_declaration, price: 120
    #   @community = @payment.community_user.community # 6 users in community
    #   @community.community_users.each do |cu| 
    #     @payment.user_saldo_modifications << FactoryGirl.create :user_saldo_modification, price: 20, community_user: cu
    #   end

    # end

    should "save when sum of user modifications is 0" do
      @payment = FactoryGirl.create(:product_declaration_with_saldos, 
        price: 100, 
        community_user: @payer, 
        saldo_price_1: 100,
        community_users_set_1: [@community.community_users.first],
        saldo_price_2: 25,
        community_users_set_1: [@community.community_users.last(4)]
        )
      
    end
  end
end
