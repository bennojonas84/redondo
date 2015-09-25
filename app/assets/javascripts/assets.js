// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $("#percent_lift_slider").change(function() {
    $("#asset_percent_lift").val($(this).val());
  });
  
  $("#asset_percent_lift").change(function() {
    $('#percent_lift_slider').val($(this).val());
  });

  if ($('#asset_percent_lift').val() == undefined || $('#asset_percent_lift').val() == '') {
    $("#asset_percent_lift").val( $("#percent_lift_slider").val() );
  } else {
    $('#percent_lift_slider').val( $('#asset_percent_lift').val() );
  }
});

function selectAsset(obj){
  $(obj).addClass('highlight').siblings().removeClass('highlight'); //selected row highlight
  var id = obj.children[0].innerHTML;
  $("#assetform").hide();
  $.ajax({
    type: "get",
    url: "/getassetinfo",
    data: {'id' : id},
    dataType: "script"
  }).success(function(data){
    $("#assetform").show();
  });
  
  return false; //prevents normal behavior
}

$(function() {
  $('tr.show-asset-form').click(function() { selectAsset(this) });
});