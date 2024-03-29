//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require trianglify
//= require webui-popover
//= require iamphill-bootstrap-offcanvas/js/bootstrap.offcanvas
//= require jquery-oembed-all/jquery.oembed
//= require swiper/swiper.jquery

$(document).on('change', '.btn-file :file', function() {
  var input = $(this),
      nums = input.get(0).files ? input.get(0).files.length : 1,
      label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  input.trigger('fileselect', [nums, label]);
});

$(document).on('ready', function(e) {
  var hash = window.location.hash;
  hash && $('ul.nav a[href="' + hash + '"]').tab('show');

  $('.nav-tabs a').on('click', function (e) {
    if ($(this).data('toggle') != 'tab') {
      return;
    }

    e.preventDefault();
    $(this).tab('show');
    var scrollmem = $('body').scrollTop();
    window.location.hash = this.hash;
    $('html,body').scrollTop(scrollmem);
  });

  var mySwiper = new Swiper ('.swiper-container', {
    spaceBetween: 40,
    slidesPerView: 3,
    nextButton: '.swiper-button-next',
    prevButton: '.swiper-button-prev',
    breakpoints: {
      // when window width is <= 480px
      480: {
        slidesPerView: 1,
        spaceBetweenSlides: 20
      }
    },
    loop: true
  });
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="webui-popover"]').webuiPopover();
  $('[data-toggle="canoe-toggle"]').on('click', function(e) {
    e.preventDefault();
    var parent_id = $(e.currentTarget).data('parent');
    var $parent = $(parent_id);
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

          $(content).appendTo($image_stage);
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
  $("a[data-tab-destination]").on('click', function() {
    var tab = $(this).attr('data-tab-destination');
    $("#"+tab).click();
  });
  $('.pattern-trianglify').css("background-image", "url('" + pattern.png() + "')");

});
