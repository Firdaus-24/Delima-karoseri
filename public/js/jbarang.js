$(function(){
    // content tbody
    $(".contentdetailjbarang").html(function(){
        let cabang = $("#ccbgjual").val()
        $.ajax({
            method: "POST",
            url: "../../ajax/getallPembelian.asp",
            data: {  cabang }
        }).done(function( msg ) {
            $(".loaderjual img").hide()
            $(".contentdetailjbarang").html(msg)
        });  
    })

    // cari barang pembelian
    $("#cbrgjual").keyup(function(){
        $(".loaderjual img").show()
        let nama = $("#cbrgjual").val().toUpperCase()
        let cabang = $("#ccbgjual").val()

        // if(nama.length > 0){
            $.ajax({
                method: "POST",
                url: "../../ajax/getallPembelian.asp",
                data: { nama, cabang }
            }).done(function( msg ) {
                $(".loaderjual img").hide()
                $(".contentdetailjbarang").html(msg)
            });  
        // }else{
        //     $(".loaderjual img").hide()
        // }
        
    })
    // tambah detail penjualan
    $('#rincianjual').submit(function(e) {
        let form = this;
        let jqty = Number($("#jqty").val())
        let qtyjual = Number($("#qtyjual").val())

        e.preventDefault(); // <--- prevent form from submitting

        if (qtyjual > jqty){
            swal("Permintaan Melebihi stok");
            return false
        }else{
            swal({
                title: "APAKAH ANDA SUDAH YAKIN??",
                text: "Penjualan Barang",
                icon: "warning",
                buttons: [
                  'No',
                  'Yes'
                ],
                dangerMode: true,
            }).then(function(isConfirm) {
                if (isConfirm) {
                    form.submit(); // <--- submit form programmatically
                } else {
                  swal("Form gagal di kirim");
                }
            })
        }
    })
})

function getStokjbarang(e){
    $("#jqty").val(e)       
    $("#qtyjual").val('')
}