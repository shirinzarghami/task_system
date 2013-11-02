require 'test_helper'
# ruby -I"lib:test" path_to_test_file"
class CommunityTest < ActiveSupport::TestCase

  test "Community should be valid with valid attributes" do
    c = FactoryGirl.build :community
    assert c.save
  end

  test "Community should set the subdomain before save" do
    c = FactoryGirl.build :community, name: 'Test'
    assert c.save
    assert_not_nil c.subdomain
  end

  test "A user can only have one role within one community" do
    attributes = ActionController::Parameters.new name: 'Test', max_users: 20, subdomain: 'test'
    c = Community.new attributes.permit!
    c.users << users(:one)
    c.admin_users << users(:one)
    assert !c.save
  end

  context "Max number of users" do
    setup do
      @community = FactoryGirl.create(:community_with_users, max_users: 2, users_count: 2)
    end

    should "Not exceed when creating community_users" do
      attributes = ActionController::Parameters.new role: 'admin', user: FactoryGirl.create(:user)
      @community.community_users.build(attributes.permit!)
      assert !@community.save
      assert @community.errors[:invitation_emails].include?("The number of community members exceeds the limitation. No new members can be added")
    end

    should "Not exceed when accepting invitation" do
      @invitation = FactoryGirl.create(:invitation, community: @community)
      assert !@invitation.accept(FactoryGirl.create(:user, email: @invitation.invitee_email))

    end
  end


end
