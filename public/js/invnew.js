$(function () {
  // get po jual by cabang
  $("#ageninvnew").change(function () {
    let cabang = $("#ageninvnew").val()
    if (cabang == "") {
      $(".invmktbaru").hide()
      $(".invmktlama").show()
    } else {
      $(".invmktlama").hide()
      $.ajax({
        method: "POST",
        url: "getpobycabang.asp",
        data: { cabang }
      }).done(function (msg) {
        $(".invmktbaru").html(msg)
      });
    }
  })
});