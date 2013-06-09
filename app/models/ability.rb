class Ability
  include CanCan::Ability

  def initialize(user, community_user, object = nil)
    # Define abilities for the passed in user here. For example:
    #
    alias_action :create, :read, :update, :destroy, :to => :crud
    @object = object
    user ||= User.new # guest user (not logged in)
    can :create, [Task, Payment]
    if user.try(:global_role) == 'admin'
      can :manage, :all
    elsif community_user.try(:admin?)
      can :manage, :all
    elsif community_user.try(:normal?)
      can :read, :all
      if object_creator?
        can :crud, [User, CommunityUser, Task, TaskOccurrence, Payment]
      end
    else

    end
  end

  def object_creator?
    @bject && @object.try(:user) == @user
  end
  #
end
