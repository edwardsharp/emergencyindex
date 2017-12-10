import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';

import { Project } from './project';

import { environment } from '../../environments/environment';
declare var PouchDB:any;


// /** Constants used to fill up our data base. */
// const NAMES = ['Maia', 'Asher', 'Olivia', 'Atticus', 'Amelia', 'Jack',
//   'Charlotte', 'Theodore', 'Isla', 'Oliver', 'Isabella', 'Jasper',
//   'Cora', 'Levi', 'Violet', 'Arthur', 'Mia', 'Thomas', 'Elizabeth'];

// let IDZ = [];
// for (let i = 0; i < 1000; i++) { 
//   IDZ.push( Math.floor(new Date(1507096743342 - (100000000 * i) ).getTime()).toString(36) );
// }

@Injectable()
export class ProjectService {

  db: any;
  total_rows: number;
  changes: any;

  dataChange: BehaviorSubject<Project[]> = new BehaviorSubject<Project[]>([]);
  get data(): Project[] { return this.dataChange.value; }

  constructor() {
    if(navigator.vendor && navigator.vendor.indexOf('Apple') > -1){
      console.log("LOADING FRUITDONW DB!");
      this.db = new PouchDB('projects', {adapter: 'fruitdown'});
    }else{
      this.db = new PouchDB('projects');
    }
    
    // PouchDB.plugin(require('pouchdb-find'));

    this.db.createIndex({
      index: {
        fields: ['_id','name']
      }
    }).then(result => {
      //console.log('index created! result',result);
    }).catch(err => {
      console.log('o noz! this.db.createIndex err:',err);
    });

    // init some data...
    // for (let i = 0; i < 10; i++) { 
    //   this.addProject(); 
    //   setTimeout(()=>{for (let i = 0; i < 50; i++) { this.addProject(); }}, 5000);
    // }

    this.changes = this.db.changes({
      since: 'now',
      live: true,
      include_docs: true
    }).on('change', change => {
      // handle change
      console.log('zomg pouchDB change:',change);
      if(change.doc["_id"]){
        const copiedData = this.data.slice();
        const project = change.doc as Project;

        const idx = copiedData.indexOf(copiedData.find(d=> d._id == change.id));
        if(change.doc["_deleted"]){
          console.log('PROJECT CHANGE: SPLICING DELETE idx:',idx,' project:',project);
          copiedData.splice(idx, 1);
        }else if(idx > -1){
          console.log('PROJECT CHANGE: SPLICING UPDATE! idx:',idx,' project:',project);
          copiedData.splice(idx, 1, project);
        }else{
          console.log('PROJECT CHANGE: PUSHING! idx:',idx,' project:',project);
          copiedData.push(project);
        }
        console.log('pushing dataChange.next... setTimeout copiedData:',copiedData);
        this.dataChange.next(copiedData);
      }
    }).on('complete', function(info) {
      // changes() was canceled
    }).on('error', function (err) {
      console.log(err);
    });

    // this.changes.cancel(); // whenever you want to cancel
        
  }

  saveProject(project:Project){
    return this.db.put(project);
  }

  addAttachment(docId:string, attachmentId:string, rev: string, attachment: Blob,type:string){
    // var attachment = new Blob(['Is there life on Mars?'], {type: 'text/plain'});
    return this.db.putAttachment(docId, attachmentId, rev, attachment, type);
  }

  removeAttachment(docId:string, attachmentId:string, rev: string){
    console.log('gonna try an remove an attachment and then, yeah...',docId,attachmentId,rev);
    return this.db.removeAttachment(docId, attachmentId, rev);
  }

  // addProject() {
  //   const copiedData = this.data.slice();
  //   copiedData.push(this.createFakeProject());
  //   this.dataChange.next(copiedData);
  // }

  /** Builds and returns a new User. */
  // private createFakeProject() {
  //   const name =
  //       NAMES[Math.round(Math.random() * (NAMES.length - 1))] + ' ' +
  //       NAMES[Math.round(Math.random() * (NAMES.length - 1))];
  //   const id = IDZ[Math.round(Math.random() * (IDZ.length - 1))]

  //   return {
  //     id: id,
  //     name: name,
  //     email: `${name}@example.org`,
  //     org: `Testing ${IDZ.indexOf(id)}`,
  //     phone: Math.floor(100000 + Math.random() * 9000000000).toString(),
  //     notes: 'testing',
  //     status: 'new',
  //     tags: []
  //   };
  // }


  getProject(id: string): Promise<Project> {
    return this.db.allDocs({
      include_docs: true,
      attachments: true,
      descending: true,
      // revs: true,
      // revs_info: true,
      // open_revs: 'all',
      key: id
    }).then(response => {
      console.log('project.service getProject return response:',response);
      if(response.rows && response.rows[0] && response.rows[0].doc){
        return response.rows[0].doc as Project;
      }else{
        return new Project;
      }
    }, err => {
      console.log('o noz! project.service getProject err:',err);
    });
  }


  getProjects(limit:number,skip:number): void {
    //environment.couch_host
    // return Promise.resolve(PROJECTS);
    return this.db.allDocs({
      include_docs: true,
      attachments: false,
      descending: true,
      limit: limit,
      skip: skip
    }).then(response => {
      console.log('project.service getProjects returning response.rows:',response.rows);
      const retItems = response.rows
        .filter(row => !row["id"].startsWith('_design'))
        .map(row => row.doc as Project);
      this.total_rows = retItems.length;
      console.log('project.service getProjects returning retItems:',retItems);
      this.dataChange.next(retItems);

    });
  }

  removeProject(project: Project): Promise<any>{
    return this.db.remove(project._id, project._rev);
  }


  find(q:string): Observable<any[]> {

    let regexp = new RegExp(q, 'i');
    return this.db.find({
      selector: {name: {$regex: regexp}},
      fields: ['_id', 'name'],
      // sort: [{_id: 'desc'}],
      // limit: 25,
      // skip: 0,
    }).then(res => res["docs"]);
  }


}
