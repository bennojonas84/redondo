// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $('#star').raty({
    readOnly: true,
    score: function() {
      return $(this).attr('data-score');
    },
    width: 150
  });

  $('a.fancybox').fancybox();

  $('#visitsTab a').click(function(e) {
    e.preventDefault();
    $(this).tab('show');

      $(".jThumbnailScroller").thumbnailScroller({
          scrollerType:"clickButtons",
          scrollerOrientation:"horizontal",
          scrollEasing:"easeOutCirc",
          scrollEasingAmount:800,
          acceleration:4,
          scrollSpeed:800,
          noScrollCenterSpace:10,
          autoScrolling:0,
          autoScrollingSpeed:2000,
          autoScrollingEasing:"easeInOutQuad",
          autoScrollingDelay:500
      });
  });

  // Build the map to show when clicking on a Map tab
  $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
    // create the searchable Visits Index Page Map Tab
    if ($(this).attr('href') == "#visits_map") {
      // get the visits coordinates
      var visits_coordinates = new Array(gon.visits_coordinates);
      console.log("the map tab is shown")
      buildVisitsIndexMap(visits_coordinates, "map");
    };
    // create the non-searchable Visit Detail Page Map Tab
    if ($(this).attr('href') == '#visit_map') {
      var visit_coordinates = new Array(new Array(gon.visit_coordinates));
      buildVisitsIndexMap(visit_coordinates, "visitMap");
    };
  });

  $('a.associated_images_link').click(function(e){
    e.preventDefault();
    asset_id_ul_sel = "#thumbs_scroll_" + $(this).data('asset-id');
//    $(this).addClass('hide');
//    $(asset_id_ul_sel).removeClass('hide').addClass('show');
    $(asset_id_ul_sel).css('visibility', 'show');
  });

  // Create an Esri Map in a DOM element specified by the given selector
  function buildVisitsIndexMap(coordinatesArray, selector) {
    var map;
    var _coordinatesArray = coordinatesArray;
    var _selector = selector;

    require(["esri/map","esri/tasks/locator", "esri/geometry/Extent", "esri/geometry/webMercatorUtils", "esri/graphic","esri/symbols/SimpleMarkerSymbol", "esri/geometry/screenUtils", "esri/geometry/Point", "esri/geometry/Multipoint", "esri/SpatialReference", "esri/request", "dojo/_base/Color", "dojo/domReady!"], function(Map, Locator, Extent, webMercatorUtils, Graphic, SimpleMarkerSymbol, screenUtils, Point, Multipoint, SpatialReference, esriRequest, Color) {

      var initial = true;
      var FIPS = [];
      var clusterLayer = null;
      var popupOptions = {
        "markerSymbol": new esri.symbol.SimpleMarkerSymbol("circle", 20, null, new dojo.Color([0,0,0,0.25])),
        "marginLeft": "20",
        "marginTop": "20"
      };

      map = new Map(_selector, {
        center: _coordinatesArray[0][0],
        zoom: 12,
        basemap: 'streets',
        slider: true
      });

      locator = new Locator("http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer");
      $('#btn-locate').on("click", locate);

      locator.on("address-to-locations-complete", function(evt) {
        if(evt.addresses.length > 0) {
          result = evt.addresses[0];
          $('#address').val(result.address);

          attributes = result.attributes;

          var minx = parseFloat(attributes.Xmin);
          var maxx = parseFloat(attributes.Xmax);
          var miny = parseFloat(attributes.Ymin);
          var maxy = parseFloat(attributes.Ymax);
          var lng = 0;
          var lat = 0;
          var no_results = true;

          // check wether visits exists or not in searched area
          for (var i = 0 - 1; i < clusterLayer._clusterData.length; i++) {
            lon = clusterLayer._clusterData[i].lon;
            lat = clusterLayer._clusterData[i].lat;
            if (minx < lon && maxx > lon && miny < lat && maxy > lat) {
              no_results = false;
              break;
            };
          };
          if (no_results == true)
          {
            alert("There are no visits done in this area. Please input other address.");
            // $("#spinner").addClass("hide");
            return;
          }
        }
      })

      function showLocation() {
        map.graphics.clear();
        _coordinatesArray[0].forEach(function(array) {
          console.log(array);
          var point = new Point(array[0], array[1]);
          var symbol = new SimpleMarkerSymbol().setStyle("square").setColor(new Color([255,0,0,0.5]));
          var graphic = new Graphic(point,symbol);
          map.graphics.add(graphic);
        })
      }
      // Perform the geocode. This function runs when the "Locate" button is pushed
      function locate() {
        var address = {
          SingleLine: $('#address').val()
        };
        var options = {
          address: address,
          outFields: ["*"]
        };
        // optionally return the out fields if you need to calculate the extent of the geocoded point
        locator.addressToLocations(options);
        // $('#spinner').removeClass('hide');
        setTimeout(function(){
          // $('#spinner').addClass('hide');
          if (validAddress == false) {
            $('#address').val("");
            $('#address').attr("placeHolder", "Invalid Zipcode");
          };
        }, 6000);
      };

      function addClusters(resp) {
        console.log("visits returned:", resp);
        // var visitInfo = {};
        // var image_content;
        // var wgs = new esri.SpatialReference({"wkid":4326});
        // visitInfo.data = dojo.map(resp.visits, function(v) {
        // })
      }

      function error(err) {
        console.log("something failed: ", err);
      }

      map.on("load", showLocation);
      // This will show visits clusters and 
      // map.on("load", function() {
      //   map.disableScrollWheelZoom();
      //   map.disableKeyboardNavigation();

      //   // hide the popup's ZoomTo link as it doesn't make sense for cluster features
      //   dojo.style(dojo.query("a.action.zoomTo")[0], "display", "none");

      //   // initFunctionality(map);

      //   // get visit's information
      //   var visits = esriRequest({
      //     url:"/visits",
      //     handleAs: "json"
      //   });
      //   visits.then(addClusters, error);
      // });

    });
  }

  // Ajax call to set a visit's image to_download flag attribute
  // to let an agent download only selected images of a visit
  $('input[type="checkbox"].checkbox-image-gallery').click(function(e) {
    var _value = $(this).prop('checked');
    var _image_index = $(this).data('index');
    var _visit_id = $(this).data('visit-id');
    var _url = '/visits/' + _visit_id + '/image_to_download'
    $.ajax({
      type: "POST",
      url: _url,
      data: {id: _visit_id, to_download: _value, image_index: _image_index}
    })
  })

});