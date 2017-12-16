json.extract! project, :id, :title, :first_date, :location, :dates, :artist_name, :collaborators, :home, :contact, :links, :description, :created_at, :updated_at
json.url project_url(project, format: :json)
