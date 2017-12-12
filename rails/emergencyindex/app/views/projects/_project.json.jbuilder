json.extract! project, :id, :name, :email, :phone, :title, :first_date, :location, :dates, :artist_name, :collaborators, :home, :contact, :links, :description, :image_href, :created_at, :updated_at
json.url project_url(project, format: :json)
