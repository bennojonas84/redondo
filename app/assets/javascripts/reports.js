// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  $("#start_date").datepicker({
    defaultDate: '-1y',
    dateFormat: 'yy-mm-dd'
  });
  $(".datepicker").datepicker({
    dateFormat: 'yy-mm-dd'
  });
});