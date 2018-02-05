class AdminController < ApplicationController
  
  before_action :authenticate_user!
  before_action :require_admin

  # skip_before_action :verify_authenticity_token if Rails.env.development?

  def index
    @q = Project.ransack(params[:q])
    # @projects = @q.result

    @users_q = User.ransack(params[:users_q])
    # @users = User.limit(1000)

    @volume = Volume.new
  end

  #get /admin/users-list.js
  def users_list

    @users_q = User.ransack(params[:q])
    @users = @users_q.result(distinct: true).page(params[:page])

    if @users.blank? and params[:q][:admin_true]
      #try to look for adminz...
      params[:q].delete(:admin_true)
      @users_q = User.ransack(params[:q])
      @users = @users_q.result(distinct: true).page(params[:page])
    end

    respond_to do |format|
      format.js { render :users_list }
    end
  end

  #POST /admin/new_user
  def new_user

    @user = User.new(user_params)
    
    passwd = Devise.friendly_token.first(25)
    @user.password = passwd
    @user.password_confirmation = passwd

    @users_q = User.ransack(params[:q])
    @users = @users_q.result(distinct: true) #.page(params[:page])

    if @user.phone.blank?
      @user.phone = 0
    end

    respond_to do |format|
      if @user.save
        format.js { render :users_list }
      else
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  #get /admin/user_edit
  def user_edit
    @user = User.find(user_params[:id])
  end

  #post /admin/update_user
  def update_user
    @user = User.find(user_params[:id])
    @users_q = User.ransack(params[:q])
    @users = @users_q.result(distinct: true) #.page(params[:page])

    @email_changed = user_params[:email] != @user.email
    @new_email = user_params[:email]

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.js { render :users_list }
      else
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  #DELETE /admin/delete_user
  def delete_user
    @user = User.find(user_params[:id])
    @users_q = User.ransack(params[:q])
    @users = @users_q.result(distinct: true) #.page(params[:page])
    respond_to do |format|
      if @user.destroy
        format.js { render :users_list }
      else
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  #post /admin/resend_user_confirmation
  def resend_user_confirmation
    @user = User.find(user_params[:id])
    @user.resend_confirmation_instructions
    respond_to do |format|
      format.json { render json: {}, status: 200 }
    end
  end
  #post /admin/reset_user_password
  def reset_user_password
    @user = User.find(user_params[:id])
    @user.send_reset_password_instructions
    respond_to do |format|
      format.json { render json: {}, status: 200 }
    end
  end

  #post /admin/user_admin
  def user_admin
    @user = User.find(user_params[:id])
    @user.admin = !@user.admin

    @users_q = User.ransack(params[:q])
    @users = @users_q.result(distinct: true) #.page(params[:page])
    respond_to do |format|
      if @user.save
        format.js { render :users_list }
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
        format.js { render :volumes_list }
      else
        format.js { render json: @volume.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  #GET /admin/edit_volume
  def edit_volume
    if params[:volume] and params[:volume][:id]
      @volume = Volume.find(volume_params[:id])
    else
      @volume = Volume.new
    end
  end

  #PATCH /admin/update_volume
  def update_volume
    @volume = Volume.find(volume_params[:id])

    respond_to do |format|
      if @volume.update_attributes(volume_params)
        format.js { render :volumes_list }
      else
        format.json { render json: @volume.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  #DELETE /admin/delete_volume
  def delete_volume
    @volume = Volume.find(volume_params[:id])

    respond_to do |format|
      if @volume.projects.count == 0 and @volume.destroy
        format.js { render :volumes_list }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  #get /admin/projects_list.js
  def projects_list
    ransack_projects

    respond_to do |format|
      format.js { render :projects_list}
    end
  end

  #DELETE /admin/delete_project
  def delete_project
    @project = Project.find(params[:project][:id])
    ransack_projects

    respond_to do |format|
      if @project.destroy
        format.js { render :projects_list }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  #post /admin/project_toggle_publish
  def project_toggle_publish
    @project = Project.find(params[:project][:id])
    @project.published = !@project.published
    ransack_projects

    respond_to do |format|
      if @project.save(validate: false)
        format.js { render json: {}, status: 200 }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  private 
  def require_admin
    render_403 unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:id, :email, :name, :phone, :postal)
  end

  def volume_params
    params.require(:volume).permit(:id, :name, :year, :open_date_string, :close_date_string, :official)
  end

end
