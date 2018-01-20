class AdminController < ApplicationController
  
  before_action :authenticate_user!
  before_action :require_admin

  def index
  end

  def users
    respond_to do |format|
      format.json { render :users }
    end
  end

  #POST /admin/new_volume
  def new_volume

    @volume = Volume.new(volume_params)

    respond_to do |format|
      if @volume.save
        format.json { render :volumes, status: :created }
      else
        format.json { render json: @volume.errors, status: :unprocessable_entity }
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
