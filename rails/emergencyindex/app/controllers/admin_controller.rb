class AdminController < ApplicationController
  
  before_action :authenticate_user!
  before_action :require_admin

  def index
  end

  private 
  def require_admin
    render_404
  end
end
