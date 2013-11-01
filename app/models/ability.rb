class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.patron?
      can :read, Author
      can :read, Book

      can :show, Checkout, patron_id: user.id
      can :show, Reservation, user_id: user.id
      can :show, User, id: user.id

      can :create, Reservation
    elsif user.distributor?
      can :read, Author
      can :read, Book

      can :show, Reservation, user_id: user.id
      can :show, Strike, patron_id: user.id
      can :show, User, id: user.id

      can :create, Reservation
      can :create, Checkout
      can :create, Strike

      can :manage, Checkout, patron_id: user.id
      can :manage, Checkout, distributor_id: user.id
      can :manage, Checkout, distributor_check_in_id: user.id
      can :manage, Strike, distributor_id: user.id
    elsif user.librarian?
      can :manage, :all
    elsif user.technical_admin?
      can :read, Author
      can :read, Book
      can :read, Checkout

      can :manage, Reservation
      can :manage, Strike
      can :manage, User
    else
      can :read, Author
      can :read, Book
    end
  end
end
