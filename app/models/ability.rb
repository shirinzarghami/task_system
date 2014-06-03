class Ability
  include CanCan::Ability

  def initialize(community_user)
    @community_user = community_user

    alias_action :create, :read, :update, :destroy, :to => :crud
    if community_user.try(:user).try(:global_admin?)
      can :manage, :all
    else
      if community_user.try(:admin?)
        # Read, update and destroy everything in the community
        limit_by_community_for_action [:read, :update, :destroy]
        # Create everything
        can :create, [Task, TaskOccurrence, Payment, ProductDeclaration, Comment, Invitation, UserSaldoModification, CommunityUser]
        can [:edit, :update], Compensation
      else
        # Read all stuff in community
        limit_by_community_for_action :read

        # Create everything except CommunityUser
        can :create, [Task, TaskOccurrence, Payment, ProductDeclaration, Comment, Invitation, UserSaldoModification]

        # Only update / destroy what was created by themselve
        can [:update, :destroy], [Task, CommunityUser, Comment], user_id: community_user.user_id
        can [:update, :destroy], TaskOccurrence, task: {user_id: community_user.user_id}
        can [:update, :destroy], Invitation, invitor_id: community_user.user_id
        can [:update, :destroy], UserSaldoModification, payment: {community_user_id: community_user.id}
        can [:update, :destroy], Payment, community_user_id: @community_user.id
      end
    end


  end

  def limit_by_community_for_action actions
    can actions, [Task, TaskOccurrence, Invitation, CommunityUser], :community_id => @community_user.community.id
    can actions, Comment, commentable: {community: @community_user.community}
    can actions, UserSaldoModification, payment: {community_user: {community_id: @community_user.id}}
    can actions, Payment, community_user: {community_id: @community_user.community.id}
  end

  # can :manage, [Task, TaskOccurrence, Invitation, CommunityUser], :community_id => community_user.community.id
  # can :manage, Payment, community_user: {community_id: community_user.community.id}
  # can :manage, Comment, commentable: {community_id: community_user.id}
  # can :manage, UserSaldoModification, payment: {community_user: {community_id: community_user.id}}
  
end
