$(document).ready(function(){
    // validasi tambah satuan
    $('#formorjul').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
        
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "Order Penjualan Customer",
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

    // aktifasi sat
    $('.btn-orjual').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "Delete Order Penjualan",
            icon: "warning",
            buttons: [
              'No',
              'Yes'
            ],
            dangerMode: true,
        }).then(function(isConfirm) {
            if (isConfirm) {
                window.location.href = e.target.href // <--- submit form programmatically
            } else {
              swal("Request gagal di kirim");
            }
        })
    })

})