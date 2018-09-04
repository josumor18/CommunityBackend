require 'test_helper'

class CommunityMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @community_member = community_members(:one)
  end

  test "should get index" do
    get community_members_url
    assert_response :success
  end

  test "should get new" do
    get new_community_member_url
    assert_response :success
  end

  test "should create community_member" do
    assert_difference('CommunityMember.count') do
      post community_members_url, params: { community_member: { id_community: @community_member.id_community, id_user: @community_member.id_user, isAdmin: @community_member.isAdmin } }
    end

    assert_redirected_to community_member_url(CommunityMember.last)
  end

  test "should show community_member" do
    get community_member_url(@community_member)
    assert_response :success
  end

  test "should get edit" do
    get edit_community_member_url(@community_member)
    assert_response :success
  end

  test "should update community_member" do
    patch community_member_url(@community_member), params: { community_member: { id_community: @community_member.id_community, id_user: @community_member.id_user, isAdmin: @community_member.isAdmin } }
    assert_redirected_to community_member_url(@community_member)
  end

  test "should destroy community_member" do
    assert_difference('CommunityMember.count', -1) do
      delete community_member_url(@community_member)
    end

    assert_redirected_to community_members_url
  end
end
