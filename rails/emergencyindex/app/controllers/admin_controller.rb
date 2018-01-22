class AdminController < ApplicationController
  
  before_action :authenticate_user!
  before_action :require_admin

  # skip_before_action :verify_authenticity_token if Rails.env.development?

  def index
    @q = Project.ransack(params[:q])
    # @projects = @q.result

    @users_q = User.ransack(params[:users_q])
    # @users = User.limit(1000)

  end

  #get /admin/users-list.js
  def users_list

    @users_q = User.ransack(params[:q])
    @users = @users_q.result(distinct: true) #.page(params[:page])

    if @users.blank? and params[:q][:admin_true]
      #try to look for adminz...
      params[:q].delete(:admin_true)
      Rails.logger.debug "\n\n #{params[:q].inspect} \n\n"
      @users_q = User.ransack(params[:q])
      @users = @users_q.result(distinct: true) #.page(params[:page])
    end

    respond_to do |format|
      format.js { render :users_list }
    end
  end

  #get /admin/projects_list.js
  def projects_list
    ransack_projects

    respond_to do |format|
      format.js { render :projects_list}
    end
  end

  #POST /admin/new_user
  def new_user

    @user = User.new(user_params)
    
    passwd = Devise.friendly_token.first(25)
    @user.password = passwd
    @user.password_confirmation = passwd

    if @user.phone.blank?
      @user.phone = 0
    end

    respond_to do |format|
      if @user.save
        format.json { render json: {}, status: :created }
      else
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  #POST /admin/new_volume
  def new_volume

    @volume = Volume.new(volume_params)

    respond_to do |format|
      if @volume.save
        format.json { render json: {}, status: :created }
      else
        format.json { render json: @volume.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private 
  def require_admin
    render_403 unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:email, :name, :phone, :postal)
  end

  def volume_params
    params.require(:volume).permit(:year, :open_date_string, :close_date_string)
  end

end
