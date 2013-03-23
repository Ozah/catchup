
$(document).bind("mobileinit", function() { // We change default values
    $.mobile.defaultPageTransition = "none";
});

function getPosition(sendGeoLocPosition) {
  if ( navigator.geolocation ) {
    //alert("geolocalisation supported");
    navigator.geolocation.getCurrentPosition( 
        sendGeoLocPosition, 
        errorCallback,
        {
          enableHighAccuracy : true,
          timeout : 5000,
          maximumAge : 60000 //60 seconds
        }
      );
  } else {
    alert("geolocalisation not supported");
  // geolocalisation not supported
  }
}

var info = $("#info");

var errorCallback = function(error){
    switch(error.code)
    {
      case error.PERMISSION_DENIED:
        info.innerHTML = "User denied the request for Geolocation."
        break;
      case error.POSITION_UNAVAILABLE:
        info.innerHTML = "Location information is unavailable."
        break;
      case error.TIMEOUT:
        info.innerHTML = "The request to get user location timed out."
        break;
      case error.UNKNOWN_ERROR:
        info.innerHTML = "An unknown error occurred."
        break;
    }  

}

//prevents scrolling of the page
//$(document).bind("touchmove",function(event){
//    event.preventDefault();
//});