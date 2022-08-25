$(document).ready(function(){
    // approve permintaan barang
    $('.btnApprovepb').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "APA ANDA SUDAH YAKIN??",
            text: "Approve permintaan barang",
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