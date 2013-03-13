(function($) {

    $(document).bind("mobileinit", function() { // We change default values
        $.mobile.defaultPageTransition = "none"
    });

    

})(jQuery);



//prevents scrolling of the page
//$(document).bind("touchmove",function(event){
//    event.preventDefault();
//});