$(document).ready(function(){
    // validasi tambah vendor
    $('#formVendor').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "form master vendor",
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

    
    let keybrgvendor
    let keybrgjnsvendor

    // ajax getbarang
    const getbarangVendor = () =>{
        let venagenID = $("#venagenID").val()
        $.ajax({
            method: "POST",
            url: "getbarang.asp",
            data: { keybrgvendor, venagenID, keybrgjnsvendor}
        }).done(function( msg ) {
            $(".contentBrgVen").html(msg)
        });  
    }

    // get rincian barang
    $("#keybrgvendor").keyup(function(){
        keybrgvendor = $("#keybrgvendor").val() //kategori barang
        getbarangVendor()
        
    })
    $("#keybrgjnsvendor").keyup(function(){
        keybrgjnsvendor = $("#keybrgjnsvendor").val() //jenis barang
        getbarangVendor()
    })


    // aktifasi vendor
    $('.btn-aktifvendor').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "APAKAH ANDA YAKIN??",
            text: "delete vendor",
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
    // delete barang vendor
    $('.btn-aktifdvendor').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "APAKAH ANDA YAKIN??",
            text: "delete rincian barang vendor",
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