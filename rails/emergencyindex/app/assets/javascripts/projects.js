// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

Dropzone.autoDiscover = false;

function getParameterByName(name) {
  var match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
  return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
}

$(document).on('ready turbolinks:load', function() {

  $('#projects-table tbody tr td').unbind('click');
  $('#projects-table tbody tr td').click(function () {
    location.href = $(this).parent().data('project-href');
  });
  $('#projects-table tbody tr td.has-action').unbind('click');

  setTimeout(function(){
    // $('#project_description').focus();
    // console.log('gonna resize a textarea!!!');
    $('textarea').each(function() {
      $(this).trigger('autoresize');
    });

    if( $('.nav-search-row input[type="search"]').val().length && $('.projects-search-field').length ){
      $('.projects-search-field').val($('.nav-search-row input[type="search"]').val());
    }

  }, 100);
  

  if(getParameterByName('q%5Bname_or_title_or_venue_or_home_or_first_date_or_tags_name_or_description_cont%5D')){
    // eek!
    $('#q_name_or_title_or_venue_or_home_or_first_date_or_tags_name_or_description_cont').val(
      getParameterByName('q%5Bname_or_title_or_venue_or_home_or_first_date_or_tags_name_or_description_cont%5D')
    )
  }

  //when navigating between pages we need to call this (fuckin' turbolinkz) 
  $.rails.refreshCSRFTokens();

  $('.datepicker').pickadate({
    selectMonths: true,
    selectYears: 15,
    today: false,
    clear: false,
    format: 'yyyy/mm/dd',
    formatSubmit: 'yyyy/mm/dd',
    min: '1900/01/01',
    max: '2099/12/31',
    onStart: function(){
      this.set( 'select', '2016/01/01' )
    }
  });

  if(!$(".dropzone").find('.dz-default').length){
    var mockFile = { 
      name: $('input[name="project[attachment_file_name]"]').val(), 
      size: $('input[name="project[attachment_file_size]"]').val() };

    $(".dropzone").dropzone({
      url: $('#project-form').attr('action'),
      method: 'put', 
      paramName: 'project[attachment]',
      uploadMultiple: false,
      createImageThumbnails: false,
      maxFilesize: 100, //mb
      maxFiles: 1,
      ignoreHiddenFiles: true,
      acceptedFiles: 'image/*',
      addRemoveLinks: true,
      headers: {
        'X-CSRF-Token': $('input[name="authenticity_token"]').val()
      },
      init: function() {
        if($('input[name="project[attachment_file_name]"]').val() != ''){
          // Call the default addedfile event handler
          this.emit("addedfile", mockFile);

          // And optionally show the thumbnail of the file:
          this.emit("thumbnail", mockFile, $('input[name="project[attachment_url]"]').val());
          // Or if the file on your server is not yet in the right
          // size, you can let Dropzone download and resize it
          // callback and crossOrigin are optional.
          // this.createThumbnailFromUrl(mockFile, $('input[name="project[attachment_url]"]').val());

          // Make sure that there is no progress bar, etc...
          this.emit("complete", mockFile);
          // this.emit("maxfilesreached", mockFile);
          // this.options.maxFiles = 0;
          // this._updateMaxFilesReachedClass();
          this.removeEventListeners();
        }
        this.on("removedfile", function(){
          this.setupEventListeners();
        });

        this.on("complete", function(file){
          if(file.xhr.response.match(/Image needs/)){
            $('#attachment-success').addClass('hidden');
            $('#attachment-error').removeClass('hidden');
            this.removeFile(file);
          }else{
            $('#attachment-success').removeClass('hidden');
            $('#attachment-error').addClass('hidden');
          }
          $('.dz-remove').addClass('hidden');
        });

      },

    });
  }
  
  $('.delete-project').unbind('click');
  $('.delete-project').click(function(e){
    e.preventDefault();
    //e.stopPropagation();
    if(confirm("Are you sure?")){
      $.ajax({
        url: "/admin/delete_project",
        method: "DELETE",
        data: { project: { id : $(this).data('project-id') } },
        success: function(){
           Materialize.toast('Project deleted!', 5000)
        }
      });
    }
    else{
      return false;
    }
  });

});
