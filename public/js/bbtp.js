$(document).ready(function () {
  // cek cabang
  $('#cabangbp').change(function () {
    let cabang = $("#cabangbp").val()
    if (cabang == "") {
      $(".lbbtpbaru").hide()
      $(".lbbtplama").show()
    } else {
      $(".lbbtplama").hide()
      $.ajax({
        method: "POST",
        url: "getNoProd.asp",
        data: { cabang }
      }).done(function (msg) {
        $(".lbbtpbaru").html(msg)
      });
    }
  })

  // pencarian master beban
  $("#keybpd").keyup(function () {
    let nama = $("#keybpd").val()
    $.post("getnamabeban.asp", { nama }, function (data) {
      $(".contentBebanProses").html(data)
    })
  })

})