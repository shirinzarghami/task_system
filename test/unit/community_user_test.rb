require 'test_helper'

class CommunityUserTest < ActiveSupport::TestCase

  test "At least one user in the community should be an admin" do
    community = FactoryGirl.create(:community_with_users, users_count: 2)
    user1, user2 = community.members.first(2)

    assert community.community_users.first.update_attributes(role: 'normal')
    community_user = community.community_users.last
    assert !community_user.update_attributes(role: 'normal')
    assert community_user.errors.count == 1

    assert !community_user.destroy

  end
end
