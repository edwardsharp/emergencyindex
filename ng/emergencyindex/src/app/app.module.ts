import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppMaterialModule } from './app-material.module';

import { AppComponent } from './app.component';
import { ProjectComponent } from './project/project.component';

import { RouterModule, Routes }   from '@angular/router';
import { HomeComponent } from './home/home.component';
const appRoutes: Routes = [
  { 
    path: 'project',  
    pathMatch: 'full',
    component: ProjectComponent 
  },
  { 
    path: '',  
    pathMatch: 'full',
    component: HomeComponent 
  }
  // ,{ 
  //   path: '',
  //   redirectTo: '/foobar',
  //   pathMatch: 'full'
  // }
  // ,{ path: '**', component: PageNotFoundComponent }
];


@NgModule({
  declarations: [
    AppComponent,
    ProjectComponent,
    HomeComponent
  ],
  imports: [
    RouterModule.forRoot(
      appRoutes
      // ,{ enableTracing: true } // <-- debugging purposes only
    ),
    BrowserModule,
    BrowserAnimationsModule,
    AppMaterialModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
