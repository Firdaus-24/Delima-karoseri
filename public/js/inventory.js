$(document).ready(function(){
    // add barang
    $('.addBrg').click(function(){
        let clone = $( ".dpermintaan:first" ).clone()
        let last = $(".dpermintaan:last")
        clone.insertAfter(last)
        
    })
    // delete barang
    $('.minBrg').click(function(){
        if ($(".dpermintaan").length > 1 ){
            $(".dpermintaan").last().remove()
        }
    })
    
    // validasi tambah
    $('#formpbarang').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "form permintaan barang",
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

    // // aktifasi rak
    // $('.btn-aktifrak').click(function(e){
        
    //     e.preventDefault(); // <--- prevent click
        
    //     swal({
    //         title: "YAKIN UNTUK DI HAPUS??",
    //         text: "delete master rak",
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
