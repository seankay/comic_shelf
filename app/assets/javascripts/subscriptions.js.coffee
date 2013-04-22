jQuery ->
  if typeof Stripe == "undefined"
    return
  else
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    subscription.setupForm()

subscription =
  setupForm: ->
    $('.edit_subscription').submit ->
      $('input[type=submit]').prop('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true

  getCard: ->
    card =
      {
        number: $('#card_number').val(),
        cvc: $('#card_code').val(),
        exp_month: $('#card_month').val(),
        exp_year: $('#card_year').val(),
        address_zip: $('#zip_code').val(),
      }

  card_valid: ->
    card = subscription.getCard()
    for key, val of card
      console.log(card[val])
      return false unless card[val].length
    return true

  processCard: ->
    Stripe.createToken(subscription.getCard(), subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#subscription_stripe_card_token').val(response.id)
      $('.edit_subscription')[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').prop('disabled', false)
