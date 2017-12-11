import { TestBed, inject, async, fakeAsync, tick } from '@angular/core/testing';

import { Project, ProjectService } from './index';

describe('ProjectService', () => {
  
  let project: Project;
  let service: ProjectService;

  const NAMES = ['Neida', 'Bettina', 'Steve', 'Shena', 'Janella', 'Marge', 'Malka', 'Coleman', 
    'Susanna', 'Catrina', 'Frederica', 'Robert', 'Isidro', 'Veta', 'Fermin', 'Lajuana', 
    'Porter', 'Emeline', 'Magdalene', 'Richard'];
  const LAST_NAMES = ['Barmore', 'Jumper', 'Preiss', 'Strange', 'Kouba', 'Hsu', 'Rivers', 
    'Keating', 'Yerkes', 'Marcinkowski', 'Beardsley', 'Owsley', 'Loach', 'Howey', 'Vanderpool', 
    'Karst', 'Happ', 'Shea', 'Hartung', 'Cuomo']

  let IDZ = [];
  for (let i = 0; i < 1000; i++) { 
    IDZ.push( Math.floor(new Date(1507096743342 - (100000000 * i) ).getTime()).toString(36) );
  }

  let createFakeProject = function() {
    const name =
        NAMES[Math.round(Math.random() * (NAMES.length - 1))] + ' ' +
        LAST_NAMES[Math.round(Math.random() * (LAST_NAMES.length - 1))];
    const id = IDZ[Math.round(Math.random() * (IDZ.length - 1))]

    let project = new Project;
  
    project._id = id;
    project.name = name;
    project.email = `${name}@example.org`;
    project.phone = Math.floor(100000 + Math.random() * 9000000000).toString();
    
    project.title = `Testing ${IDZ.indexOf(id)}`;
    project.first_date = '';
    project.location = '';
    project.dates = '';
    project.artist_name = '';
    project.collaborators = '';
    project.home = '';
    project.contact = '';
    project.links = '';
    project.description = '';

    return project;
  }


  beforeEach(() => {
    const injector = TestBed.configureTestingModule({
      providers: [ProjectService]
    });

    service = injector.get(ProjectService);
    project = createFakeProject();

  });

  it('should have a working service', function(){
    expect(service).toBeTruthy();
  });

  it('should create factory projects', function(){
    expect(project).toEqual(jasmine.any(Project));
    expect(project._id && project.name).toBeDefined();
  });

  //https://stackoverflow.com/questions/47748102/testing-angular-2-services-with-jasmine-using-async-promises
  it('should be able to CREATE, READ, UPDATE, & DELETE a new project (async)',
    async (done) => {
      //CREATE
      let response = await service.saveProject(project);
      expect(response.ok).toEqual(true);

      //READ
      let _project = await service.getProject(project._id);
      // expect(_project).toEqual(jasmine.any(Project));
      expect(_project.name).toEqual(project.name);

      //UPDATE
      _project.name = 'zomg d00d';
      response = await service.saveProject(_project);
      expect(response.ok).toEqual(true);

      //DELETE
      _project = await service.getProject(project._id);
      response = await service.removeProject(_project);
      expect(response.ok).toEqual(true);

      done();
  });


  it('should LIST projects (async)',
    async (done) => {
      //CREATE
      let response = await service.saveProject(project);
      expect(response.ok).toEqual(true);

      //LIST
      response = await service.getProjects(10,0);
      expect(response.length).toBeGreaterThanOrEqual(1);
      
      //DELETE
      let _project = await service.getProject(project._id);
      response = await service.removeProject(_project);
      expect(response.ok).toEqual(true);

      done();
  });

  //it('should be able to FIND projects (async)');


});
