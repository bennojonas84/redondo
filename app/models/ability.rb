class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/bryanrite/cancancan/wiki/Defining-Abilities
    if user.is_a?(Admin) && user.is_developer?
      can :manage, :all
      # can :manage, CmsContent
    elsif user.is_a?(Admin) && user.is_uber_admin?
      can :manage, Asset do |asset|
        user.company_ids.include?(asset.company_id)
      end
      can :manage, Agent do |agent|
        user.company_ids.include?(agent.company_id)
      end
      can :manage, Report
      # can :read, Company, id: user.company_ids 
      # can :manage, CmsContent
      can :read, Visit
    elsif user.is_a?(Agent) && user.is_company_admin?
      can :manage, Asset, company_id: user.company_id
      can :manage, Agent, company_id: user.company_id
      can :manage, Report
      can :read, Visit, company: user.company
    elsif user.is_a?(Agent) && !user.is_company_admin?
      can :read, Visit, company: user.company
    end
  end
end
