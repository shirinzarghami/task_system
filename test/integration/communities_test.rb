require 'test_helper'

class CommunitiesTest < ActionDispatch::IntegrationTest
  setup do
    @community = FactoryGirl.create :community_with_users
    @user = @community.members.first

    sign_in
  end

  context "Communities index page" do
    setup do
      visit communities_path
    end

    should "Show the communities of which the user is a member" do
      assert page.has_selector?('table th', text: 'Name')
      assert page.has_selector?('table td a', text: @community.name)
      assert page.has_selector?('table td', text: 'admin')
    end

  end
end
