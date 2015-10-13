$ ->
  $(document).foundation

  $mf = $('#month-field')
  $ri = $('#room_id')
  $rt = $('#room-tmp')
  $ti = $('#teacher_id')
  $tt = $('#teacher-tmp')

  if $rt.val() != '0'
    $('#room-field').hide()
  if $tt.val() != '0'
    $('#teacher-field').hide()

  update_cal = (callback=null) ->
    m = $('#m').val()
    if 0 == parseInt(m)
      $mf.children('table').css('opacity', '0.25')
      $mf.children('.switch.day').addClass('disabled')
      return
    $mf.show()
    $.ajax
      type: 'GET'
      url: './cal.php',
      data: 
        'y': $('#y').val()
        'm': m
      dataType: 'html'
      success: (data) ->
        $mf.html data
        console.log(callback)
        callback()
      error: ->
        $mf.html 'カレンダーのロードに失敗しました'

  $('#y').change update_cal
  $('#m').change update_cal

  $rt.change ->
    rtv = $rt.val()
    if parseInt(rtv) == 0
      $('#room-field').show()
      $ri.val('')
      return
    $('#room-field').hide()
    $ri.val(rtv)

  $tt.change ->
    rtv = $tt.val()
    if parseInt(rtv) == 0
      $('#teacher-field').show()
      $ti.val('')
      return
    $('#teacher-field').hide()
    $ti.val(rtv)

  $('#check-all-button').click ->
    $("[name=day\\[\\]]").prop 'checked', true
  $('#uncheck-all-button').click ->
    $("[name=day\\[\\]]").prop 'checked', false

  $('#quick-year-button').click ->
    $("#m").val("0")
    $("#m").change()
  $('#quick-today-button').click ->
    date = new Date()
    y = date.getFullYear()
    m = date.getMonth() + 1
    d = date.getDate()
    $("#y").val(y)
    $("#m").val(m)
    update_cal ->
      $(".switch.day>input[value!=" + d + "]").prop 'checked', false

  $('.error').hide()
  $('#submit-button').click ->
    noerror = true
    if $('#univ_id').val() == ''
      noerror = false
      $('#univ_id').parents().addClass('error')
      $('#univ_id').addClass('error')
      $('#univ_id').parents().next().show()
    else
      $('#univ_id').removeClass('error')
    if noerror
      $('#main_form').submit()
  $('[data-toggle-day]').click ->
    i = parseInt($(@).attr('data-toggle-day')) + 1
    $switchs = $("table td:nth-child(7n+#{i}) input")
    $switchs.prop('checked', !$switchs.eq(0).prop('checked'))

