class IndexesController < ApplicationController
  def index
  end

  def terms
    if params[:q]
      @q = Project.ransack(params[:q])
      @terms = @q.result(distinct: true)
        .published
        .paginate({page: params[:page], per_page: 100})
    else
      @q = Project.ransack(params[:q])
      @terms = Project.published
      .unscope(:order)
      .tag_counts
      .order('LOWER(name)')
      .paginate({page: params[:page], per_page: 100})
    end
    
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

    @q = Project.ransack(params[:q])
    #TODO: group_by{|project| project.contact_name}
    @contributors = @q.result(distinct: true)
      .published
      .joins(:volume)
      .select(:contact_name, :title, :id, 'volumes.name as volume_name')
      .unscope(:order).order(:contact_name)
      .paginate({page: params[:page], per_page: 100})
  end

  def places
    @q = Project.ransack(params[:q])
    @paginate_places = @q.result(distinct: true)
      .select(:venue, :title, :name, :id)
      .published
      .unscope(:order).order(:venue)
      .group(:venue, :title, :id)
      .paginate({page: params[:page], per_page: 100})
    @places = @paginate_places
      .group_by{|project| project.venue}
  end


end
