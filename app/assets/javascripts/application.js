//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require trianglify
//= require webui-popover
//= require zenscroll/zenscroll
//= require iamphill-bootstrap-offcanvas/js/bootstrap.offcanvas
//= require uservoice

$(document).on('change', '.btn-file :file', function() {
  var input = $(this),
      numFiles = input.get(0).files ? input.get(0).files.length : 1,
      label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  input.trigger('fileselect', [numFiles, label]);
});

$(document).on('ready', function(e) {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="webui-popover"]').webuiPopover();
  $('[data-toggle="canoe-toggle"]').on('click', function(e) {
    var parent_id = $(e.target).data('parent');
    $parent = $(parent_id);
    $parent.find('.canoe-toggle-item').each(function(index, object) {
      $object = $(object);
      if($object.hasClass('hidden')) {
        $object.removeClass('hidden');
      } else {
        $object.addClass('hidden');
      }
    });

    var focus_id = $(e.target).data('focus');
    $focus = $(focus_id)
    $focus.focus()
  });
  zenscroll.setup(null, 60)
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
  $('.btn-file :file').on('fileselect', function(event, numFiles, label) {
    event.target.form.submit();
  });
  $('.pattern-trianglify').css("background-image", "url('" + pattern.png() + "')");
});
