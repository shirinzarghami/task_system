require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Community should not be valid without a subdomain" do
    c = Community.new name: 'test community', max_users: 20
    assert !c.save
  end
end
