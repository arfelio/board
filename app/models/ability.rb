class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :moderator
      can :manage, Advertisement
      can :manage, Comment
      can :manage, Category
      can :read, User
    elsif user.has_role? :user
      can :manage, Advertisement do |advertisement|
        advertisement.try(:user) == user
      end
      can :read, User
      can :read, Advertisement
      can :create, Advertisement
      can :manage, Comment do |comment|
        comment.try(:user) == user
      end
      can :read, Comment
      can :create, Comment
    else
      can :read, :all
      cannot :read, Category
    end
  end
end
