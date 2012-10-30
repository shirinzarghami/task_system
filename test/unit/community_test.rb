require 'test_helper'
# ruby -I"lib:test" path_to_test_file"
class CommunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Community should be valid with valid attributes" do
    c = Community.new name: 'Test', max_users: 20, subdomain: 'test'
    assert c.save
  end

  test "Community should set the subdomain before save" do
    c = Community.new name: 'Test', max_users: 20
    assert c.save
    assert_not_nil c.subdomain
  end

  test "A user can only have one role within one community" do
    c = Community.new name: 'Test', max_users: 20, subdomain: 'test'
    c.users << users(:one)
    c.admin_users << users(:one)
    assert !c.save
  end
end
