//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require trianglify
//= require webui-popover
//= require zenscroll/zenscroll
//= require iamphill-bootstrap-offcanvas/js/bootstrap.offcanvas
//= require jquery-oembed-all/jquery.oembed

$(document).on('change', '.btn-file :file', function() {
  var input = $(this),
      nums = input.get(0).files ? input.get(0).files.length : 1,
      label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  input.trigger('fileselect', [nums, label]);
});

$(document).on('ready', function(e) {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="webui-popover"]').webuiPopover();
  $('[data-toggle="canoe-toggle"]').on('click', function(e) {
    e.preventDefault();
    var parent_id = $(e.currentTarget).data('parent');
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
  $('[data-toggle="preview"]').each(function(k, body) {
    var $body = $(body);
    var $links = $body.find('.auto_link');
    var $image_stage = $($body.data('image-stage'));
    var $embed_stage = $($body.data('embed-stage'));

    $links.each(function(k, v) {
      $v = $(v);
      var source_url = $v.attr('href');

      if ($image_stage) {
        var img = new Image();
        img.src = source_url;
        $(img).load(function() {


          var content = '<div class="col-xs-8">';
          content += '<div class="thumbnail">';
          content += '<img src="' + img.src+ '">';
          content += '</a>';
          content += '</div>';
          content += '</div>';

          $(content).appendTo($stage);
        });
      }

      if ($embed_stage) {
        $item = $('<div></div>')
        $item.oembed(source_url,
          { embedMethod: 'fill',
            includeHandle: false,
            maxWidth: $embed_stage.width(),
            fallback: false});
        $item.appendTo($embed_stage);
      }
    });
  });
  var pattern = Trianglify({
    width: 1200,
    height: 600,
  });
  $('.btn-file :file').on('fileselect', function(e, nums, label) {
    var $target = $(e.target)
    if($target.data('autoupload')) {
      e.target.form.submit();
      return;
    }

    var list = $(e.target).data('list');
    var $list = $(list);
    $list.append(function() {
      return $("<li style='cursor: pointer;'><i class='fa fa-file-o' /> " + label + " <i class='fa fa-times-circle' /></li>").on('click', function(list_e) {
        $target.prop('disabled', true);
        $(list_e.target).closest('li').hide();
      });
    });

    $target.after($target.clone(true));
    $target.hide();
    $target.data('filenum', nums);
  });
  $('.pattern-trianglify').css("background-image", "url('" + pattern.png() + "')");
});
