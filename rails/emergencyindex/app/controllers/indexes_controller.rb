class IndexesController < ApplicationController
  def index
  end

  def terms
    @terms = Project.published.unscope(:order).tag_counts.order(:name)
  end

  def contributors
    @contributors = User.joins(:projects).where('projects.published = true').group('users.id').uniq
  end

  def places
    @places = Project.select(:venue, :title, :id).unscope(:order).order(:venue).group_by{|project| project.venue}
    #Project.select(:venue, :title, :id).unscope(:order).order(:venue).group(:venue, :id)
    # Project.pluck(:venue, :id, :title).group_by(:venue)
  end
end
