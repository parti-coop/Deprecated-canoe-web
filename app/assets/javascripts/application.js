//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require trianglify

$(document).on('ready', function(e) {
  var pattern = Trianglify({
    width: 1200,
    height: 600,
  });
  $('.pattern-trianglify').css("background-image", "url('" + pattern.png() + "')");
});
