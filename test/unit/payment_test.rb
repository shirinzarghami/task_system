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

  context "start saldo" do
    should "be zero for each user after creation of community" do
      @community.start_saldo_distribution.user_saldo_modifications.each do |saldo_modification|
        assert_equal 0, saldo_modification.price
      end
    end

    should "alter the saldo if the start saldo is set" do
      @start_saldo_distribution = @community.start_saldo_distribution
      @saldo_modification_1, @saldo_modification_2 = @start_saldo_distribution.user_saldo_modifications.first(2)

      @saldo_modification_1.price = 10
      @saldo_modification_2.price = -10

      assert @saldo_modification_1.save && @saldo_modification_2.save

      assert_equal 10, @saldo_modification_1.community_user.saldo
      assert_equal -10, @saldo_modification_2.community_user.saldo

    end


  end
end
