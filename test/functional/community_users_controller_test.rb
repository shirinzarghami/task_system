require 'test_helper'

class CommunityUsersControllerTest < ActionController::TestCase

  setup do
    @community = FactoryGirl.create :community_with_users
    @community_user = @community.community_users.first
  end

  context "not logged in" do
    should "not be allowed to update" do
      put :update, id: @community_user.id, community_user: {role: 'admin', id: @community_user.id}
      # assert_redirected_to community_path(@community_user.community)
      assert_redirected_to new_user_session_path
    end    
    should "not be allowed to destroy" do
      delete :destroy, id: @community_user.id
      # assert_redirected_to communities_path
      assert_redirected_to new_user_session_path
    end
  end

  context "logged in" do
    setup do
      @admin_user = @community.admin_users.first
      @normal_user1 = FactoryGirl.create(:user) and @community.users << @normal_user1
      @normal_user2 = FactoryGirl.create(:user) and @community.users << @normal_user2
      @community_user1 = CommunityUser.find_by_community_and_name @normal_user1, @community
      @community_user2 = CommunityUser.find_by_community_and_name @normal_user2, @community
    end

    context "normal user" do
      setup do
        sign_in @normal_user1
      end
      should "be allowed to destroy your own community_user" do
        delete :destroy, id: @community_user1.id
        assert_redirected_to communities_path
      end

      should "NOT be allowed to destroy not owned by you" do

      end

      should "not be allowed to update any community_user" do

      end
    end

    context "admin user" do

    end
  end


end
