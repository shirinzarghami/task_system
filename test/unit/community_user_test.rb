require 'test_helper'

class CommunityUserTest < ActiveSupport::TestCase

  test "At least one user in the community should be an admin" do
    community = FactoryGirl.create(:community_with_users, users_count: 2)
    user1, user2 = community.members.first(2)
    community_user_1, community_user_2 = community.community_users.first(2)

    community_user_1.role = 'normal'
    assert community_user_1.save

    community_user_2.role = 'normal'
    assert !community_user_2.save
    assert community_user_2.errors.count == 1

    assert !community_user_2.destroy

  end
end
