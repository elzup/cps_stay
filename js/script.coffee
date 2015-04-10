$ ->
  $(document).foundation

  $mf = $('#month-field')
  $ri = $('#room_id')
  $rt = $('#room-tmp')

  $('#room-field').hide()

  update_cal = ->
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
      error: ->
        $mf.html 'カレンダーのロードに失敗しました'

  $('#y').change update_cal
  $('#m').change update_cal

  $rt.change ->
    rtv = $rt.val()
    console.log rtv
    if parseInt(rtv) == 0
      $('#room-field').show()
      $ri.val('')
      return
    $('#room-field').hide()
    $ri.val(rtv)


