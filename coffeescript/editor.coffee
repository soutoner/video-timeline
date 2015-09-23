(($) ->
  # Document ready
  $ ->

    ## PARAMETERS
    ## -------------------------------------------------
    radioIndicatorBorder = 3

    ## EDITOR MANAGEMENT
    ## -------------------------------------------------

    # Set line indicator length initially
    $('.line-indicator').height($('.tray-wrapper').height())

    # Managing editor tray resize (really is the video wrapper what is resizable)
    $('.video-wrapper').resizable(
      containment: 'parent',
      handles: 's',
      resize: (event, ui) -> resizeTray($('.body-wrapper').height() - ui.size.height)
    )

    # Managing elements on window resize
    $(window).resize( ->
      # Resize video wrapper
      if trayIsMinimized()
        resizeVideo($('.body-wrapper').height() - $('.time-bar-icons-wrapper').height())
      else
        resizeVideo($('.body-wrapper').height() - $('.tray-wrapper').height())
        resizeTrayContent()
    )

    # Time lines indicator on draggable
    $('.radio-indicator').draggable(
      axis: 'x',
      containment: 'parent',
      drag: (event,ui) ->
        # Also move the indicator (with a little margin)
        $('.line-indicator').css('left', ui.position.left + radioIndicatorBorder)
        # And the filled bar
        $('.filled-bar').width(ui.position.left)
      , stop: (event, ui) ->
        # Set video progress when movement is stoped
        setCurrentTimeVideo(pop.duration())
    )
    # Set current time when you click on time bar
    $('.full-time-bar').click( (e) ->
      offSet = $(this).offset()
      relX = e.pageX - offSet.left
      percentage = relX / $('.full-time-bar').width()
      setCurrentTimeVideo(percentage)
    )

    # Minimize tray icon
    ogTrayWrapperHeight = $('.tray-wrapper').height()
    $('.minimize-wrapper button').click( ->
      if trayIsMinimized()
        resizeVideo($('.body-wrapper').height() - ogTrayWrapperHeight, true)
      else
        ogTrayWrapperHeight = $('.tray-wrapper').height()
        resizeVideo($('.body-wrapper').height() - $('.time-bar-icons-wrapper').height(), true)

      $('.line-indicator').slideToggle()
      $('.tracks-wrapper').slideToggle()
    )


    ## AUXILIAR FUNCTIONS
    # Resize tray and all the elements along
    resizeTray = (newHeight) ->
      if !trayIsMinimized()
        # Resize tray wrapper
        $('.tray-wrapper').height(newHeight)
        # Resize tray contentr
        resizeTrayContent()

    # Resize tray content to fit the wrapper
    resizeTrayContent = ->
      # Resize line indicator
      $('.line-indicator').height($('.tray-wrapper').height())

    # Resize video wrapper
    resizeVideo = (newHeight, animated = false) ->
      if animated
        $('.video-wrapper').animate(height: newHeight)
      else
        $('.video-wrapper').height(newHeight)

    # Set progress bar at a certain point (percentage)
    setProgressBar = (progress = 50) ->
      # Move filled bar
      $('.filled-bar').width(progress + '%')
      # Radio correction because its not centered with filled bar
      radioCorrection = (radioIndicatorBorder*100)/$('.full-time-bar').width()
      # Move radio pointer
      $('.radio-indicator').css('left', progress - radioCorrection + '%')
      # Move line indicator
      $('.line-indicator').css('left',  progress + '%')

    # Return progress bar percentage
    getProgressBar = ->
      # Move filled bar
      $('.filled-bar').width()/$('.full-time-bar').width()

    ## BOOLEANS
    # Returns if tray is minimized (i.e. tracks wrapper is not visible)
    trayIsMinimized = ->
      $('.tracks-wrapper').is(':hidden')
    # Return if the radio indicator is being dragged
    indicatorBeingDragged = ->
      $('.radio-indicator').is('.ui-draggable-dragging')

    ## VIDEO MANAGEMENT
    ## -------------------------------------------------

    wrapper = Popcorn.HTMLYouTubeVideoElement('#video')

    wrapper.src = "https://www.youtube.com/watch?v=TLLG_3Aiq80"

    pop = Popcorn( wrapper )

    pop.load()

    ## EVENTS
    # on durationchange set duration of the video
    wrapper.addEventListener('durationchange', (e) ->
      $('.status-container span.total-time').text(pop.duration().toHHMMSS())
    )

    # on timeupdate change set current time of the video and progress
    wrapper.addEventListener('timeupdate', (e) ->
      $('.status-container span.current-time').text(pop.currentTime().toHHMMSS())
      if !indicatorBeingDragged()
        setProgressBar((pop.currentTime()/pop.duration())*100)
    )
    # on playing set button text as pause
    wrapper.addEventListener('playing', (e) ->
      $('.status-container button').text('Pause')
    )

    # on pause set button text as play
    wrapper.addEventListener('pause', (e) ->
      $('.status-container button').text('Play')
    )

    # Play/pause button
    $('.status-container button').click( ->
      if pop.paused()
        pop.play()
      else
        pop.pause()
    )

    ## AUXILIARY FUNCTION
    # Set current time of the video given the percentage of the progress bar
    setCurrentTimeVideo = (percentage) ->
      pop.currentTime(percentage * pop.duration())

    ## HELPERS
    # Seconds to HH:MM:SS (YouTube) format
    Number.prototype.toHHMMSS = ->
      secs = Math.ceil(this)
      hours = Math.floor(secs / 3600)
      minutes = Math.floor((secs - (hours * 3600)) / 60)
      seconds = secs - (hours * 3600) - (minutes * 60)

      (if hours != 0 then hours + ':' else '') +
        (if hours > 0 then minutes.twoDigits() else minutes)  + ':' +
        seconds.twoDigits()

    Number.prototype.twoDigits = ->
      if this > 9 then '' + this else '0' + this

) jQuery

