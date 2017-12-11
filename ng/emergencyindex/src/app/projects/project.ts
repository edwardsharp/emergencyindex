export class Project {
  _id: string;
  _rev?: string;
  
  name: string;
  email: string;
  phone: string;

  title: string;
  first_date: string;
  location: string;
  dates: string;
  artist_name: string;
  collaborators?: string;
  home: string;
  contact?: string;
  links?: string;
  description: string;
  image_href?: string;
}
