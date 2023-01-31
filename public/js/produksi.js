$(document).ready(function () {
    $("#prodagen").change(function () {
        let agen = $("#prodagen").val()

        if (!agen) {
            $(".lproductlama").show()
        } else {
            $(".lproductlama").hide()
            $.ajax({
                method: "POST",
                url: "../../ajax/getallbom.asp",
                data: { agen }
            }).done(function (msg) {
                $(".lproductbaru").html(msg)
            });
        }
    })
    // get barang by agen
    // $("#produkcabang").change(function(){
    //     let cabang = $("#produkcabang").val()

    //     if(!cabang){
    //         $("#produkbrg").show()
    //     }else{
    //         $("#produkbrg").hide()
    //         $.ajax({
    //             method: "POST",
    //             url: "../../ajax/getBarangTypeProduksi.asp",
    //             data: { cabang }
    //         }).done(function( msg ) {
    //             $(".produkbrg").html(msg)
    //         });
    //     }
    // })
    // // get barang productd_add
    // $("#cdetailProdiksi").keyup(function(){
    //     let nama = $("#cdetailProdiksi").val()
    //     let cabang = $("#productCabang").val()
    //     let productID = $("#productID").val()
    //     let tbodylama = $(".contentProductD").html()
    //     if(nama.length > 0){
    //         $(".clearfix").show()
    //         $.ajax({
    //             type: "POST",
    //             url: "../../ajax/getBarangProduksiByCabang.asp",
    //             data: {nama,cabang,productID}
    //         }).done(function(data){
    //             $(".contentProductD").html(data)
    //             $(".clearfix").hide()
    //         });
    //     }else{
    //         $(".contentProductD").html(tbodylama);
    //     }
    // })
})