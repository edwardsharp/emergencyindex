// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('ready turbolinks:load', function() {
  $('.indexes-collapsible').collapsible({
    onOpen: function(el) { setTimeout(function(){el[0].scrollIntoView()}, 250) }
  });
});
