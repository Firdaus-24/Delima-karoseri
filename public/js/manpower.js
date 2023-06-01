$(document).ready(function () {
  $("#kryManpower").keypress(function () {
    let nama = $("#kryManpower").val()
    let cabang = $("#cabangManpower").val()
    $.post("../../ajax/getkrymanpower.asp", { nama, cabang }).done(function (data) {
      if (data.length == 0) {
        $("#contentTblManpower").html("<h5 class='text-center mt-4' style='color:red;align-items:center'>DATA TIDAK DI TEMUKAN</h5>")
      } else {
        $("#contentTblManpower").html(data)
      }
    });

  })
})