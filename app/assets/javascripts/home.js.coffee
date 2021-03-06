Home =
  init: ->
    $('body').on 'ajax:success', '.ama-header-link', @showAmas
    $('body').on 'keyup', '#comment_body:not(.no-submit-on-enter)', @submitComment
    $('body').on 'click', '#sign-up', @showSignUpModal
    $('body').on 'click', '#login', @showLogInModal
    $('body').on 'click', '#close-modal', @closeSignUpModal
    $('body').on 'click', '#close-login', @closeLogInModal
    $('body').on 'click', '#got-it', @closeWelcome
    $('body').on 'submit', '#new_user', @checkFields
    $('body').on 'click', 'textarea, input, .upvote-container', @forceSignUp
    $('body').on 'ajax:success', '.rec-link', @showRecommended
    @startScrollHeight = $('#landing-main').height()
    $(window).on 'scroll', @makeAmasScrollable if $('.amas-container').length > 0 && $(window).width() > 1024 
    $(window).on 'scroll', @fillHeader if $(window).width() < 1024 && $('.amas-container').length > 0

  showRecommended: (event, data) ->
    $(@).find('div').text('Recommended')

  fillHeader: ->
    if $(window).scrollTop() > Home.startScrollHeight 
      $('#main-header').css('background','white')
      $('#main-header').css('box-shadow', '0px 0px 10px 0px rgba(0,0,0,0.1)')
    else
      $('#main-header').attr('style', '')

  forceSignUp: ->
    if $('.current-user-name').length < 1 
      Home.showSignUpModal()

  checkFields: ->
    emptyName = $('#user_name').val() == ""
    emptyEmail = $('#user_email').val() == ""
    emptyPassword = $('#user_password').val() == ""
    badPassword = $('#user_password').val().length < 6
    $('#new_user input').attr('style', '')

    $('#user_name').css('border', '1px solid red') if emptyName
    $('#user_email').css('border', '1px solid red') if emptyEmail
    $('#user_password').css('border', '1px solid red') if emptyPassword
    $('#user_password').css('border', '1px solid red') if badPassword

    if emptyName || emptyEmail || emptyPassword || badPassword
      return false

  makeAmasScrollable: ->
    if $('.amas-container').length > 0
      if $(window).scrollTop() + 1 > Home.startScrollHeight 
        $('.amas-container').css 'overflow-y', 'scroll'
        $('#landing-ama').css('z-index', '2')
        $('#main-header').hide()
      else
        $('.amas-container').css 'overflow-y', 'hidden'
        $('#landing-ama').css('z-index', '0')
        $('#main-header').show()


  closeWelcome: ->
    $('#welcome').hide()

  showSignUpModal: ->
    $('.signup-overlay-container').show().addClass('animated fadeIn')
    $('#landing-ama, #landing-main').hide()

  showLogInModal: ->
    $('.login-overlay-container').show().addClass('animated fadeIn')
    $('#landing-ama, #landing-main').hide()

  closeSignUpModal: ->
    $('.signup-overlay-container').hide()
    $('#landing-ama, #landing-main').show()

  closeLogInModal: ->
    $('.login-overlay-container').hide()
    $('#landing-ama, #landing-main').show()

  submitComment: (e) ->
    console.log e.keyCode
    if e.keyCode == 13
      console.log "hey"
      $(@).parents('form').submit()
  	

  showAmas: (event, data) ->
  	$('.ama-header-tab').removeClass('active')
  	$(@).find('.ama-header-tab').addClass('active')
  	$('#amas-content').html data
  	$('.amas-date, .amas').addClass('animated fadeIn')


 ready = ->
  Home.init()
$(document).ready ready
$(document).on 'page:load', ready
