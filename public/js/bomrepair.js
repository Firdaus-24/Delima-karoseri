$(document).ready(function () {
  // get produksi repair by agen
  $("#bmrcabang").change(function () {
    let cabang = $("#bmrcabang").val()

    if (!cabang) {
      $("#pdrid-repair").html(`<option value="" readonly disabled>Pilih cabang dahulu</option>`)
    } else {
      $.ajax({
        method: "POST",
        url: "getnomorproduksi.asp",
        data: { cabang }
      }).done(function (msg) {
        return $("#pdrid-repair").html(msg)
      });
    }
  })
  // get incoming unit
  $("#pdrid-repair").change(function () {
    let pdrid = $("#pdrid-repair").val()
    if (!pdrid) {
      $("#irhid-bomrepair").val(``)
      $("#labelirhid-bomrepair").val(``)
      $("#cust-bomrepair").val(``)
      $("#brand-bomrepair").val(``)
      $("#type-bomrepair").val(``)
      $("#nopol-bomrepair").val(``)
    } else {
      $.ajax({
        method: "POST",
        url: "getnomorincoming.asp",
        data: { pdrid }
      }).done(function (msg) {
        $(`#irhid-bomrepair`).val(msg[0].IRHID)
        $(`#labelirhid-bomrepair`).val(`${msg[0].IRHID.substr(0,4)}-${msg[0].IRHID.substr(4,3)}/${msg[0].IRHID.substr(7,4)}/${msg[0].IRHID.substr(11,2)}`)
        $(`#cust-bomrepair`).val(msg[0].CUSTOMER)
        $(`#brand-bomrepair`).val(msg[0].BRANDNAME)
        $(`#type-bomrepair`).val(msg[0].TYPE)
        $(`#nopol-bomrepair`).val(msg[0].NOPOL)
        return
      });
    }
  })

  // filter pencarian barang
  $("#cbrgbmrd").keyup(function () {
    let nama = $("#cbrgbmrd").val()
    let cabang = $("#bmrdCabang-repair").val()

    $.post("getbarang.asp",{nama, cabang}, function(data){
      $(".brgBmrdRepair").html(data)
      return
    })
  })
  
  // cari divisi anggaran bom repair
  $("#bomrepairdivisi").change(function(){
    let divisi = $("#bomrepairdivisi").val()
    
    if(!divisi){
      $(".deplamarepair").show()
    }else{
      $(".deplamarepair").hide()
      $.ajax({
        method: "POST",
        url: "getdep.asp",
        data: { divisi }
      }).done(function( msg ) {
        $(".depbarurepair").html(msg)
      });
    }
  })
})

