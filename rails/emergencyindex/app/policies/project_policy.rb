class ProjectPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def index?
    true
  end

  def show?
    scope
  end

  def create?
    user
  end

  def new?
    create?
  end

  def update?
    user and project and (user.admin? or project.user_id == user.id)
  end

  def edit?
    user and project and (user.admin? or project.user_id == user.id)
  end

  def destroy?
    user and project and (user.admin? or project.user_id == user.id)
  end

  def scope
    Pundit.policy_scope!(user, project.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user and user.admin?
        scope.all
      elsif user
        scope.where(published: true)
      else
        scope.where(published: true)
      end
    end
  end
end
