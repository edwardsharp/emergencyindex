// this is a barrel file (index.ts)
// https://angular.io/guide/glossary#!#barrel

// it re-exportz yr exports make imports easier (and use fewer lines)
// e.g.  import { Project, ProjectService, ProjectComponent } from '../projects'; // index is implied

export * from './project';   
export * from './project.service'; 
export * from './project.component'; 
export * from './project-list.component'; 
