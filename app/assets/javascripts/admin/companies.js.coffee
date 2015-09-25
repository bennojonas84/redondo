jQuery ->
  $(".draggable").draggable(
    appendTo: $('#company_uber_admin')
    revert: true
    scroll: false
    helper: "clone"
  )
  $('#assigned_uber_admin>#droppable').droppable(
    hoverClass: 'hovering-for-drop'
    drop: (event, ui)-> 
      uber_admin_id = $(ui.helper[0]).data('admin_id')
      company_id = $(ui.helper[0]).data('company_id')
      _url = '/rm/SkuRun/companies/' + company_id + '/assign_uber_admin'
      $.ajax(
        type: 'POST'
        url: _url
        data: {id: company_id, admin_id: uber_admin_id}
        dataType: "script"
      )
  )