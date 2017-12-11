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
  it('should be able to CREATE a new project (async)',
    async (done) => {
      let response = await service.saveProject(project);
      expect(response).toEqual(project);
      done();
  });

	// it('should be able to CREATE and READ a new project (async)',
	//   async( (done) => {

	//   let response = await service.saveProject(project)
 //    expect(response).toEqual(project);
	 
	//   // // spyOn(service, 'saveProject').and.callThrough();
	//   // service.saveProject(project).then( 
	//   // 	response => {

	//   // 		expect(response).toEqual(project);
	//   // 		done();
	//   // 	} );

	// }));

	// it('should be able to READ a new project (async)',
	//   async( () => {

	//   return service.getProject(project._id).then(
	//     project => expect(project).toEqual(project),
	//     err => fail(err)
	//   );

	// }));

	// it('test should wait for FancyService.getTimeoutValue',
	//   fakeAsync(inject([ProjectService], (service: ProjectService) => {

	//   service.getProjects(10,0).then(
	//   	tick();
	//     projects => {expect(projects.length).toBeGreaterThan(1)}
	//   );
	// })));

  //it('should be able to UPDATE a project');

 //  it('should LIST projects (async)',
	//   async( () => {

	//   service.getProjects(10,0).then(
	//     value => expect(value).toBeTruthy()
	//   );
	// }));

  //it('should be able to DELETE projects');

  //it('should be able to FIND projects');


});
