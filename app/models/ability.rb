class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.patron?
    elsif user.distributor?
    elsif user.librarian?
      can :manage, :all
    elsif user.technical_admin?
    end
  end
end
