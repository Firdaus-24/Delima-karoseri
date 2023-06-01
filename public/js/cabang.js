$(document).ready(function(){
    // search data kode pos
    $('#kdpos').on('keyup',function(){
        $('.loaderKdpos').show()
        if ($('#kdpos').val().length > 0 ){
            // get data 
            $.get('src_kdpos.asp?key='+ $('#kdpos').val().toUpperCase(), function(data){
                $('.showkdpos').html(data)
                $('.loaderKdpos').hide()

                // get data on btn kode pos
                $('.btnCbKdpos').on('click', function(){
                    $('#kdpos').val($(this).val())
                    $('.showkdpos').html('')
                })
            })
        }else{
            $('.showkdpos').html('')
            $('.loaderKdpos').hide()
        }
    })

    // validasi tambah cabang
    $('#formcabang').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "form master cabang",
            icon: "warning",
            buttons: [
              'No',
              'Yes'
            ],
            dangerMode: true,
        }).then(function(isConfirm) {
            if (isConfirm) {
            //   swal({
            //     title: 'Success!',
            //     text: 'data berhasil di kirimkan',
            //     icon: 'success'
            //   }).then(function() {
                form.submit(); // <--- submit form programmatically
            //   });
            } else {
              swal("Form gagal di kirim");
            }
        })
    })

    // aktifasi cabang
    $('.btn-aktifCabang').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "APAKAH ANDA YAKIN??",
            text: "delete cabang",
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