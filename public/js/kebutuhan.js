$(document).ready(function(){
    // cek tombol tambah
    $('.tambahKeb').click(function(){
        $('.titlekeb').html('FORM TAMBAH')
        $('#formkeb').attr('action', 'keb_add.asp')
        $('.subkeb').html('Tambah')
        $('#id').val('')
        $('#inpnama').val('')
    })
    // cek tombol update
    $('.updatekeb').click(function(){
        let id = $(this).attr('data')
        let nama = $(this).attr('valname')

        $('.titlekeb').html('FORM UPDATE')
        $('#formkeb').attr('action', 'keb_u.asp')
        $('.subkeb').html('Update')
        $('#id').val(id)
        $('#oldnama').val(nama)
        $('#inpnama').val(nama)
    })
    
    // validasi tambah satuan
    $('#formkeb').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "form master kebutuhan permintaan",
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
    $('.btn-aktifkeb').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete master kebutuhan permintaan",
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