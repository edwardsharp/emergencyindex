import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { Routes, RouterModule }  from '@angular/router';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppMaterialModule } from './app-material.module';

import { AppComponent } from './app.component';
import { AuthComponent } from './auth/auth.component';
import { AuthService } from './auth/auth.service';
import { PageNotFoundComponent } from './page-not-found/page-not-found.component';
import { HomeComponent } from './home/home.component';
import { Project, ProjectService, ProjectComponent, ProjectListComponent } from './projects';

const appRoutes: Routes = [
  {
    path: 'auth',
    component: AuthComponent
  },
  {
    path: 'list',
    component: ProjectListComponent
  },
  { 
    path: 'project',  
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
  ,{ path: '**', component: PageNotFoundComponent }
];


@NgModule({
  declarations: [
    AppComponent,
    ProjectComponent,
    HomeComponent,
    ProjectListComponent,
    PageNotFoundComponent,
    AuthComponent
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
  providers: [ProjectService, AuthService],
  bootstrap: [AppComponent]
})
export class AppModule { }
