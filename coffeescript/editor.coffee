(($) ->
  # Document ready
  $ ->
    jQuery.fn.resizeHeightMaintainRatio = (newHeight) ->
      aspectRatio = $(this).data('aspectRatio')
      if aspectRatio == undefined
        aspectRatio = $(this).width() / $(this).height()
        $(this).data('aspectRatio', aspectRatio)
      $(this).height(newHeight)
      $(this).width(parseInt(newHeight * aspectRatio))

    # Managing editor tray resize
    $('.video-wrapper').resizable(
      containment: 'parent',
      handles: 's',
      resize: (event, ui) ->
        $('.tray-wrapper').height($('.body-wrapper').height()-ui.size.height)
        # We have to mantain margins
        verticalMargins = parseFloat($('.video-container').css('top'))+parseFloat($('.video-container').css('bottom'))
        $('.video-container').resizeHeightMaintainRatio(ui.size.height-verticalMargins)
    )

    # Managing window resize
    $(window).resize( ->
      $('.tray-wrapper').height($('.body-wrapper').height()-$('.video-wrapper').height())
    )
) jQuery

#   var pop;
#
#    document.addEventListener("DOMContentLoaded", function () {
#      var wrapper = Popcorn.HTMLYouTubeVideoElement('#video');
#    wrapper.src = 'https://www.youtube.com/watch?v=As_cvwAMYi4';
#
#      pop = Popcorn(wrapper);    });