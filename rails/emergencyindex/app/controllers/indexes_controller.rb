class IndexesController < ApplicationController
  def index
  end

  def terms
    @terms = Project.published
      .unscope(:order)
      .tag_counts
      .order('LOWER(name)')
      .paginate({page: params[:page], per_page: 100})
  end

  def term
    @projects = Project.published.tagged_with(params[:term]).pluck(:title, :name, :id)
  end

  def contributors
    # @contributors = User.joins(:projects)
    #   .where('projects.published = true')
    #   .group('users.id')
    #   .distinct
    #   .paginate({page: params[:page], per_page: 100})

    #TODO: group_by{|project| project.contact_name}
    @contributors = Project.published
      .joins(:volume)
      .select(:contact_name, :title, :id, 'volumes.name as volume_name')
      .unscope(:order).order(:contact_name)
      .paginate({page: params[:page], per_page: 100})
  end

  def places
    @paginate_places = Project.select(:venue, :title, :name, :id)
      .published
      .unscope(:order).order(:venue)
      .group(:venue, :title, :id)
      .paginate({page: params[:page], per_page: 100})
    @places = @paginate_places
      .group_by{|project| project.venue}
  end
end
