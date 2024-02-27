class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return unless user.present?

    can :manage, Reservation, user_id: user.id
    can :read, Car

    return unless user.admin?

    can :manage, Car
  end
end
