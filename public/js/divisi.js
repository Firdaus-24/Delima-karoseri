$(document).ready(function(){
    // cek tombol tambah
    $('.tambahdiv').click(function(){
        $('.titlediv').html('FORM TAMBAH')
        $('#formdiv').attr('action', 'div_a.asp')
        $('.subdiv').html('Tambah')
        $('#id').val('')
        $('#inpnama').val('')
    })
    // cek tombol update
    $('.updatediv').click(function(){
        let id = $(this).attr('data')
        let nama = $(this).attr('valname')

        $('.titlediv').html('FORM UPDATE')
        $('#formdiv').attr('action', 'div_u.asp')
        $('.subdiv').html('Update')
        $('#id').val(id)
        $('#inpnama').val(nama)
    })
    
    // validasi tambah satuan
    $('#formdiv').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "form master divisi",
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
    $('.btn-aktifdiv').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete master divisi",
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