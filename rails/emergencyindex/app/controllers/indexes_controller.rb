class IndexesController < ApplicationController
  def index
  end

  def terms
    @terms = Project.published
      .unscope(:order)
      .tag_counts
      .order(:name)
      .paginate({page: params[:page], per_page: 100})
  end

  def contributors
    @contributors = User.joins(:projects)
      .where('projects.published = true')
      .group('users.id')
      .distinct
      .paginate({page: params[:page], per_page: 100})
  end

  def places
    @paginate_places = Project.select(:venue, :title, :name, :id)
      .unscope(:order).order(:venue)
      .group(:venue, :title, :id)
      .paginate({page: params[:page], per_page: 100})
    @places = @paginate_places
      .group_by{|project| project.venue}
  end
end
