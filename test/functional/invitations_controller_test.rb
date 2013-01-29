require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase

  test "Accept invitation: the user in the invitation has logged in" do
    invitation = FactoryGirl.create :invitation_with_invitee
    params = {
      id: invitation.token,
      invitation: 'accept'
    }
    
    sign_in(:user, invitation.invitee)
    put :update, params

    assert_redirected_to community_path(invitation.community)
    assert_notice_flash
  end  

  test "Accept invitation: no user logged in but the user in the invitation exists" do
    invitation = FactoryGirl.create :invitation_with_invitee
    params = {
      id: invitation.token,
      invitation: 'accept'
    }

    put :update, params

    assert_response :success
    assert_error_flash
    assert invitation.reload and invitation.status == 'requested'
  end

  test "Accept invitation: no user logged in and the email in the invitation is not registered" do
    invitation = FactoryGirl.create :invitation
    params = {
      id: invitation.token,
      invitation: 'accept',
      user: {
        email: 'person9384309@examples.com',
        name: 'Jan Klaas',
        password: '123456',
        password_confirmation: '123456'
      }
    }

    put :update, params
    assert_redirected_to invitation_path(invitation.token)
    assert_notice_flash
    assert invitation.reload and invitation.status == 'accepted'
  end

  test "Accept invitation: a user has logged in but the e-mail does not match with the invitation" do
    invitation = FactoryGirl.create :invitation_with_invitee
    params = {
      id: invitation.token,
      invitation: 'accept'
    }
    sign_in :user, FactoryGirl.create(:user)
    put :update, params
    assert_response :success
    assert_error_flash
    assert invitation.reload and invitation.status == 'requested'
  end

  test "Accept invitation: a user has logged in but the e-mail does not match with the invitation email and this email is not registered" do
    invitation = FactoryGirl.create :invitation
    params = {
      id: invitation.token,
      invitation: 'accept',
      user: {
        email: 'person9384309@examples.com',
        name: 'Jan Klaas',
        password: '123456',
        password_confirmation: '123456'
      }
    }
    sign_in :user, FactoryGirl.create(:user)
    put :update, params
    assert_redirected_to community_path(invitation.community)
    assert_notice_flash
    assert invitation.reload and invitation.status == 'accepted'
  end

  test "Accept invitation without user params while it should have user params" do
    invitation = FactoryGirl.create :invitation
    params = {
      id: invitation.token,
      invitation: 'accept',
    }
    put :update, params
    assert_response 400

  end

# X User ingelogd == email invitation ==> accept scherm
# User ingelogd != email invitation maar WEL bestaande user ==> login als andere user
# User ingelogd != email invitation en een NIET bestaande user ==> Accept scherm als andere user
# X Geen user inglogd en invitation_email bestaat WEL ==> login als andere user
# X Geen user inglogd en invitation_email bestaat NIET ==> create nieuwe user

end
