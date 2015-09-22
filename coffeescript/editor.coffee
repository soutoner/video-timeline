(($) ->
  # Document ready
  $ ->

    # Helper resize function (maintaining aspect ratio)
    jQuery.fn.resizeHeightMaintainRatio = (newHeight) ->
      aspectRatio = $(this).data('aspectRatio')
      if aspectRatio == undefined
        aspectRatio = $(this).width() / $(this).height()
        $(this).data('aspectRatio', aspectRatio)
      $(this).height(newHeight)
      $(this).width(parseInt(newHeight * aspectRatio))

    # Set line indicator length
    $('.line-indicator').height($('.tray-wrapper').height())

    # Managing editor tray resize (really is the video wrapper what is resizable)
    $('.video-wrapper').resizable(
      containment: 'parent',
      handles: 's',
      resize: (event, ui) ->
        # Resize tray
        $('.tray-wrapper').height($('.body-wrapper').height() - ui.size.height)
        # Resize line tracks indicator
        $('.line-indicator').height($('.tray-wrapper').height())
        # We have to maintain margins
        verticalMargins = parseFloat($('.video-container').css('top')) + parseFloat($('.video-container').css('bottom'))
        $('.video-container').resizeHeightMaintainRatio(ui.size.height - verticalMargins)
    )

    # Managing tray on window resize
    $(window).resize( ->
      $('.tray-wrapper').height($('.body-wrapper').height() - $('.video-wrapper').height())
    )

    # Radio indicator of the time-bar
    $('.radio-indicator').draggable(
      axis: 'x',
      containment: 'parent',
      drag: (event,ui) ->
        # Also move the indicator (with a little margin)
        $('.line-indicator').css('left', ui.position.left + 3)
    );
) jQuery

