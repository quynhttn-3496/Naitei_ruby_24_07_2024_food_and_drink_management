# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :read, :all

    return if user.blank?

    can :manage, Review, user_id: user.id

    return unless user.admin?

    can :manage, :all
  end
end
