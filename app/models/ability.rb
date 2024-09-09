# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :read, :all
    cannot :manage, :admin_page

    return if user.blank?

    can :manage, Review, user_id: user.id
    cannot :manage, :admin_page

    return unless user.admin?

    can :manage, :all
  end
end
