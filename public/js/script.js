function validasiForm(data, e, te, ic){
    let form = data;
    e.preventDefault(); // <--- prevent form from submitting
   
    swal({
        title: "APAKAH ANDA SUDAH YAKIN??",
        text: te,
        icon: ic,
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