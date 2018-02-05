class VolumesController < ApplicationController

  def index
    @projects = Volume.find_by(name: params[:volume]).projects.published.pluck(:id, :pages)
  end

  def project
    @project = Project.find(params[:id])
  end

end
