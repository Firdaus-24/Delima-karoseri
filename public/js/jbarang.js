$(function(){
    // validasi tambah header Penjualan
    $('#formPenjualanH').submit(function(e) {

    let form = this;
    
    e.preventDefault(); // <--- prevent form from submitting
    
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "Penjualan",
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
    })

    // get stok barang
    $("input[name='ckpenjualan']").click(function(){
        const str =  $("input[name='ckpenjualan']:checked").val()
        const pieces = str.split(/[\s,]+/)
        const last = pieces[pieces.length - 1]
        
        $("#jqty").val(last)       
        $("#qtyjual").val('')
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

    // aktifasi header orjul
    // aktifasi header orjul
    // $('.btn-orjual').click(function(e){
        
    //     e.preventDefault(); // <--- prevent click
        
    //     swal({
    //         title: "YAKIN UNTUK DI HAPUS??",
    //         text: "Delete Order Penjualan",
    //         icon: "warning",
    //         buttons: [
    //           'No',
    //           'Yes'
    //         ],
    //         dangerMode: true,
    //     }).then(function(isConfirm) {
    //         if (isConfirm) {
    //             window.location.href = e.target.href // <--- submit form programmatically
    //         } else {
    //           swal("Request gagal di kirim");
    //         }
    //     })
    // })
    // // aktifasi detail orjul
    // $('.btn-aktiforjuld').click(function(e){
        
    //     e.preventDefault(); // <--- prevent click
        
    //     swal({
    //         title: "YAKIN UNTUK DI HAPUS??",
    //         text: "Delete Detail Order Penjualan",
    //         icon: "warning",
    //         buttons: [
    //           'No',
    //           'Yes'
    //         ],
    //         dangerMode: true,
    //     }).then(function(isConfirm) {
    //         if (isConfirm) {
    //             window.location.href = e.target.href // <--- submit form programmatically
    //         } else {
    //           swal("Request gagal di kirim");
    //         }
    //     })
    // })
})