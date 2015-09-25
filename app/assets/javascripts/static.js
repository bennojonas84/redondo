$(document).ready(function() {

    $(".play_button, .main_play_button").click(function() {
        $(this).next().trigger('click');
    });

});