// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.all
//= require jquery.ui.effect.all
//= require jquery_ujs
//= require jquery.thumbnailScroller
//= require mb/bootstrap
//= require mb/modern-business
//= require fancybox
//= require_tree .

$(document).ready(function() {
	$('a.fancybox').fancybox();
})

$(document).ajaxStart(function () {
	$("#loading").show();
}).ajaxStop(function () {
	$("#loading").hide();
});

function selectCompany(obj) {
	id = $(obj).data('id');
	$(obj).parent().addClass('highlight').siblings().removeClass('highlight'); //selected row highlight
	//var id = obj.children[0].innerHTML;
	$("#companyform").hide();
	$.ajax({
		type: "get",
		url: "/rm/SkuRun/getcompanyinfo",
		data: {'id' : id},
		dataType: "html"
	}).success(function(data){
		$("#companyform").html(data);			
		$("#companyform").show();
	});
	return false; //prevents normal behavior
}

$(function() {
	// $('td.show-company-form').click(function() {selectCompany(this)});
	$('td.show-company-form').click(function() {
		id = $(this).data('id');
		window.location = "/rm/SkuRun/companies/" + id;
	})
});

function selectphotoFile(input){
	if (input.files && input.files[0]) {
		var reader = new FileReader();

		reader.onload = function (e) {
			$('#agent_avatar').attr('src', e.target.result);
		};

		reader.readAsDataURL(input.files[0]);
	}
}
function photoBrowse(){
	$('#agent_photo').click();
}

function selectphotoFileAsset(input){
	if (input.files && input.files[0]) {
		var reader = new FileReader();

		reader.onload = function (e) {
			$('#asset_avatar').attr('src', e.target.result);
		};

		reader.readAsDataURL(input.files[0]);
	}
}
function photoBrowseAsset(){
	$('#asset_image').click();
}

function selectimageFile(obj){
	var ext = $("#asset_image").val().split('.').pop().toLowerCase();
	if ( $.inArray(ext, ['png']) == -1 ) {
		alert("This file is not a PNG. Please only upload PNG format files to the Asset upload tool. Thanks.");
  	$("#asset_image").val('');
  }
	
	$('#imagepath').val($(obj).val());
}
function imageBrowse(){
	$('#asset_image').click();
}
function selectlogoFile(obj){
	$('#logopath').val($(obj).val());
}
function logoBrowse(){
	$('#company_logo').click();
}

function viewvisitdetail(obj){
	visit_id = $(obj).data('id');
	window.location.href="/visitdetail?id=" + visit_id
}

$(function() {
	$('tr.view-visit-detail').click(function() {
		viewvisitdetail(this);
	});
});

function closeDiv(obj){
	$(obj).parent().css({display:'none'});
}

// Activates the Carousel
$('.carousel').carousel({
  interval: 5000
})

// Activates Tooltips for Social Links
$('.tooltip-social').tooltip({
  selector: "a[data-toggle=tooltip]"
})
$(document).ready(function() {
	$('#subnav-header li.dropdown a.submenu_dropdown').hover( 
		function() {
			if ($(window).width() > 752) {
				$(this).next().fadeIn(400);
			}
		},
		function() {
			if ($(window).width() > 752) {
				var current = $(this);
				setTimeout(function() {
					if (current.next('.subnav-head-menu').data('over') != "true") {
						current.next().fadeOut(50);
					}
				}, 10);
			}
		}
	);

	$('#subnav-header .subnav-head-menu').hover(
		function() {
			if ($(window).width() > 752) {
				$(this).data('over', "true");
			}
		},
		function() {
			if ($(window).width() > 752) {
				$(this).data('over', "false");
				$(this).fadeOut(50);
			}
		}
	);
});