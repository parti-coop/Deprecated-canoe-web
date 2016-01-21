//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require trianglify
//= require webui-popover
//= require zenscroll/zenscroll
//= require iamphill-bootstrap-offcanvas/js/bootstrap.offcanvas
//= require uservoice

$(document).on('ready', function(e) {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="webui-popover"]').webuiPopover();
  zenscroll.setup(null, 60)
  $('[data-anchor="proposal"]').on('click', function(e) {
    var proposal_id = $(e.target).data('proposal-id');
    $('.proposal').removeClass('proposal--highlight');

    var $the_proposal = $('#proposal_' + proposal_id);
    zenscroll.intoView($the_proposal.get(0));
    $the_proposal.addClass('proposal--highlight');
  });
  var pattern = Trianglify({
    width: 1200,
    height: 600,
  });
  $('.pattern-trianglify').css("background-image", "url('" + pattern.png() + "')");
});
