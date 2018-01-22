class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :postal])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone, :postal])
  end

  def render_403
    render file: "#{Rails.root}/public/403.html",  status: :not_found
  end

  def ransack_projects
    # whoa! https://github.com/activerecord-hackery/ransack/issues/218#issuecomment-16504630
    if params[:q]
      params[:q][:combinator] = 'and'
      params[:q][:groupings] = []
      custom_words = params[:q].delete(:name_or_title_or_venue_or_home_or_first_date_or_tags_name_or_description_cont)
      custom_words.split(' ').each_with_index do |word, index|
        params[:q][:groupings][index] = {name_or_title_or_venue_or_home_or_first_date_or_tags_name_or_description_cont: word} 
      end

      @q = policy_scope(Project).search(params[:q])
      @projects = @q.result(distinct: true)

    else
      @q = policy_scope(Project).ransack(params[:q])
      @projects = @q.result(distinct: true)
    end
  end
end
