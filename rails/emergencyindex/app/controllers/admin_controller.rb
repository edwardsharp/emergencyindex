class AdminController < ApplicationController
  
  before_action :authenticate_user!
  before_action :require_admin

  # skip_before_action :verify_authenticity_token if Rails.env.development?

  def index
    @q = Project.ransack(params[:q])
    # @projects = @q.result
  end

  def users
    respond_to do |format|
      format.json { render :users }
    end
  end

  #get /admin/projects_list.js
  def projects_list
    @q = Project.ransack(params[:q])
    @projects = @q.result #.page(params[:page])
    
    respond_to do |format|
      format.js { render :projects_list}
    end
  end

  #POST /admin/new_volume
  def new_volume

    @volume = Volume.new(volume_params)

    respond_to do |format|
      if @volume.save
        format.json { render :volumes, status: :created }
      else
        format.json { render json: @volume.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private 
  def require_admin
    render_403 unless current_user.admin?
  end

  def volume_params
    params.require(:volume).permit(:year, :open_date_string, :close_date_string)
  end
end
