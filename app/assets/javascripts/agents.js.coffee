# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  selectAgent = (obj) ->
    $(obj).parent().addClass('highlight').siblings().removeClass('highlight')
    id = $(obj).data('id')
    $('#agentform').hide()
    $.ajax(
      type: 'get'
      url: '/getagentinfo'
      data: {'id': id}
      dataType: 'script'
    ).success((data) -> $('#agentform').show())
    return false

  $('td.show-agent-form').click( ()-> selectAgent(this) )