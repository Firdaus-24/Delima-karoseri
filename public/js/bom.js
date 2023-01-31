$(document).ready(function () {
   // get barang by agen
   $("#bomcabang").change(function () {
      let cabang = $("#bomcabang").val()

      if (!cabang) {
         $("#bombrg").show()
      } else {
         $("#bombrg").hide()
         $.ajax({
            method: "POST",
            url: "../../ajax/getBarangTypeProduksi.asp",
            data: { cabang }
         }).done(function (msg) {
            $(".bombrg").html(msg)
         });
      }
   })
   // get barang productd_add
   $("#cdetailbom").keyup(function () {
      let nama = $("#cdetailbom").val()
      let cabang = $("#bomdCabang").val()
      let bomid = $("#bmid").val()
      let tbodylama = $(".contentBOMD").html()
      if (nama.length > 0) {
         $(".clearfixbom").show()
         $.ajax({
            type: "POST",
            url: "../../ajax/getBarangProduksiByCabang.asp",
            data: { nama, cabang, bomid }
         }).done(function (data) {
            $(".contentBOMD").html(data)
            $(".clearfixbom").hide()
         });
      } else {
         $(".contentBOMD").html(tbodylama);
      }
   })
})