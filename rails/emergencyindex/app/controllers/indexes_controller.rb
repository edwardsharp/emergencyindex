class IndexesController < ApplicationController
  def index
  end

  def terms
    @terms = Project.published.unscope(:order).tag_counts.order(:name).paginate({page: params[:page], per_page: 1})
  end

  def contributors
    @contributors = User.joins(:projects).where('projects.published = true').group('users.id').distinct.paginate({page: params[:page], per_page: 1})
  end

  def places
    # @paginate_places = Project.select(:venue, :title, :id).unscope(:order).order(:venue).paginate({page: params[:page], per_page: 1})
    # @places = @paginate_places.group_by{|project| project.venue}
    
    @paginate_places = Project.select(:venue, :title, :name, :id)
    .unscope(:order).order(:venue)
    .group(:venue, :title, :id)
    .paginate({page: params[:page], per_page: 1})

    @places = @paginate_places
    .group_by{|project| project.venue}
    #Project.select(:venue, :title, :id).unscope(:order).order(:venue).group(:venue, :id)
    # Project.pluck(:venue, :id, :title).group_by(:venue)
  end
end
