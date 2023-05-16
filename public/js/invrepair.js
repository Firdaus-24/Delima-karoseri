$(function () {
  // get po jual by cabang
  $("#agenRepairMkt").change(function () {
    let cabang = $("#agenRepairMkt").val()
    if (cabang == "") {
      $(".inv-repairmkt-baru").hide()
      $(".inv-repairmkt-lama").show()
    } else {
      $(".inv-repairmkt-lama").hide()
      $.ajax({
        method: "POST",
        url: "getporepair.asp",
        data: { cabang }
      }).done(function (msg) {
        $(".inv-repairmkt-baru").html(msg)
      });
    }
  })
});
const getPoRepair = (id) => {
  $.ajax({
    method: "POST",
    url: "getdetailpo.asp",
    data: { id },
    dataType: 'json',
  }).done(function (msg) {
    if (msg.JTDATE != "1900-01-01") {
      $("#tgljt-repair").val(msg.JTDATE)
    } else {
      $("#tgljt-repair").val('')
    }
    $("#custid-repair").val(msg.CUSTID)
    $("#custname-repair").val(msg.CUSTNAME)
    $("#ppn-repair").val(msg.PPN)
    $("#diskon-repair").val(msg.DISKONALL)
    $("#keterangan-repair").val(msg.KETERANGAN)
    $("#tw-repair").val(msg.TIMEWORK)
    $("#uangmuka-repair").val(format(msg.UANGMUKA))
  });
}