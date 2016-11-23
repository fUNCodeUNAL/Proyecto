class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if Teacher.where(username: user.username).count > 0 
      can :manage, :all
    else
      can :read, [Contest, Problem]
      can :manage, Submission
      can :register, Contest
    end
  end
end
