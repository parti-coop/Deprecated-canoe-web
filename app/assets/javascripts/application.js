//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require trianglify
//= require webui-popover

//= require uservoice

$(document).on('ready', function(e) {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="webui-popover"]').webuiPopover();
  var pattern = Trianglify({
    width: 1200,
    height: 600,
  });
  $('.pattern-trianglify').css("background-image", "url('" + pattern.png() + "')");
});
