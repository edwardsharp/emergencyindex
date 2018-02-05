class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action do
    ransack_projects(without_projects: true)
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :postal])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone, :postal])
  end

  def render_403
    render file: "#{Rails.root}/public/403.html",  status: :not_found
  end

  def ransack_projects user_scope=nil, without_projects=nil
    # whoa! https://github.com/activerecord-hackery/ransack/issues/218#issuecomment-16504630
    if params[:q] and params[:q][:name_or_title_or_venue_or_home_or_first_date_or_tags_name_or_description_cont]
      params[:q][:combinator] = 'and'
      params[:q][:groupings] = []
      custom_words = params[:q].delete(:name_or_title_or_venue_or_home_or_first_date_or_tags_name_or_description_cont)
      custom_words.split(' ').each_with_index do |word, index|
        params[:q][:groupings][index] = {name_or_title_or_venue_or_home_or_first_date_or_tags_name_or_description_cont: word} 
      end
      if user_scope
        @q = policy_scope(Project).where(user: current_user).search(params[:q])
      else
        @q = policy_scope(Project).search(params[:q])
      end
    else
      if user_scope
        @q = policy_scope(Project).where(user: current_user).ransack(params[:q])
      else
        @q = policy_scope(Project).ransack(params[:q])
      end
    end

    unless without_projects
      @projects = @q.result(distinct: true).paginate({page: params[:page], per_page: 25})
    end
  end
end
