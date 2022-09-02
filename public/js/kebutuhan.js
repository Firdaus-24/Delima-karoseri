$(document).ready(function(){
    // cek tombol tambah
    $('.tambahDep').click(function(){
        $('.titleDep').html('FORM TAMBAH')
        $('#formDep').attr('action', 'keb_add.asp')
        $('.subDep').html('Tambah')
        $('#id').val('')
        $('#inpnama').val('')
        $('#divid').val('')
    })
    // cek tombol update
    $('.updateDep').click(function(){
        let id = $(this).attr('data')
        let nama = $(this).attr('valname')
        let divisi = $(this).attr('divid')
                
        $('.titleDep').html('FORM UPDATE')
        $('#formDep').attr('action', 'keb_u.asp')
        $('.subDep').html('Update')
        $('#id').val(id)
        $('#oldnama').val(nama)
        $('#inpnama').val(nama)
        // $('#divid selected').val(divisi)
        $("#divid option").filter(function() {
            //may want to use $.trim in here
            return $(this).val() == divisi;
        }).prop('selected', true);
    })
    
    // validasi tambah satuan
    $('#formDep').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "form master Departement",
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
    $('.btn-aktifDep').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete master departement",
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