import { TestBed, inject } from '@angular/core/testing';

import { ProjectService } from './project.service';

describe('ProjectService', () => {
  
  let projectz = [];
  const NAMES = ['Maia', 'Asher', 'Olivia', 'Atticus', 'Amelia', 'Jack',
	  'Charlotte', 'Theodore', 'Isla', 'Oliver', 'Isabella', 'Jasper',
	  'Cora', 'Levi', 'Violet', 'Arthur', 'Mia', 'Thomas', 'Elizabeth'];

	let IDZ = [];
	for (let i = 0; i < 1000; i++) { 
	  IDZ.push( Math.floor(new Date(1507096743342 - (100000000 * i) ).getTime()).toString(36) );
	}

  let createFakeProject = function() {
    const name =
        NAMES[Math.round(Math.random() * (NAMES.length - 1))] + ' ' +
        NAMES[Math.round(Math.random() * (NAMES.length - 1))];
    const id = IDZ[Math.round(Math.random() * (IDZ.length - 1))]

    return {
      id: id,
      name: name,
      email: `${name}@example.org`,
      org: `Testing ${IDZ.indexOf(id)}`,
      phone: Math.floor(100000 + Math.random() * 9000000000).toString(),
      notes: 'testing',
      status: 'new',
      tags: []
    };
  }

  let addProject = function() {
	  projectz.push( createFakeProject() );
	}


	// init some data...
	for (let i = 0; i < 10; i++) { 
	  addProject(); 
	  //async add more projectz
	  //setTimeout(()=>{for (let i = 0; i < 50; i++) { addProject(); }}, 5000);
	}



  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ProjectService]
    });



  });

  it('should be created', inject([ProjectService], (service: ProjectService) => {
    expect(service).toBeTruthy();
  }));


  //it('should be able to CREATE a new project')

  //it('should be able to READ a project')

  //it('should be able to UPDATE a project')

  //it('should LIST projects')

  //it('should be able to DELETE projects')

  //it('should be able to FIND projects')


});
