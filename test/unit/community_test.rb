require 'test_helper'
# ruby -I"lib:test" path_to_test_file"
class CommunityTest < ActiveSupport::TestCase

  test "Community should be valid with valid attributes" do
    c = build :community
    assert c.save
  end

  test "Community should set the subdomain before save" do
    c = build :community, name: 'Test'
    assert c.save
    assert_not_nil c.subdomain
  end

  test "A user can only have one role within one community" do
    c = build :community, name: 'Test', max_users: 20, subdomain: 'test'
    c.users << users(:one)
    c.admin_users << users(:one)
    assert !c.save
  end

  context "Max number of users" do
    setup do
      @community = create :community_with_users, max_users: 2, users_count: 2
    end

    should "Not exceed when creating community_users" do
      @user = create :user
      @community_user = create :community_user, user: @user, role: 'admin'

      @community.community_users << @community_user

      assert !@community.save
      assert @community.errors[:invitation_emails].include?("The number of community members exceeds the limitation. No new members can be added")
    end

    should "Not exceed when accepting invitation" do
      @invitation = create(:invitation, community: @community)
      assert !@invitation.accept(create(:user, email: @invitation.invitee_email))

    end
  end


end
