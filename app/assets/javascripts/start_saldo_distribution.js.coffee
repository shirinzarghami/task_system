check_start_saldo_sum = () ->
  sum = 0
  $('input.start-saldo').each ->
    sum += parseFloat($(this).val())

  valid_distribution = (sum == 0)

  $('input[type=submit]').attr('disabled', !valid_distribution)

  if valid_distribution
    $('input.start-saldo').parents('div.control-group').removeClass('error')
  else
    $('input.start-saldo').parents('div.control-group').addClass('error')

jQuery ->
  $('input.start-saldo').change(check_start_saldo_sum)