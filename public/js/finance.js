$(document).ready(function(){
    // validasi tambah satuan
    $('#formApprove').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
        
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "Dana Permintaan Barang",
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
    $('.btn-appYN').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "Delete Approve Permintaan Barang ",
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

    // send email
    $(".modalSendEmailMemo").click(function(){
        let id = $(this).attr('data-id')
        $("#idappmemo").val(id)
    })

})