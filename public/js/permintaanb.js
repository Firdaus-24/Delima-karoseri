$(document).ready(function(){
    // getdepartement
    $("#pbdivisi").change(function(){
        let divisi = $("#pbdivisi").val()
        
        if(!divisi){
            $(".deplama").show()
        }else{
            $(".deplama").hide()
            $.ajax({
                method: "POST",
                url: "getdep.asp",
                data: { divisi }
            }).done(function( msg ) {
                $(".depbaru").html(msg)
            });
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

    // get nama barang by vendor
    $("#cpbarang").keyup(function(){
        let nama = $("#cpbarang").val()
        let cabang = $("#pbcabang").val()
        $.ajax({
            method: "POST",
            url: "../../ajax/getbrgvendor.asp",
            data: { nama, cabang }
        }).done(function( msg ) {
            $(".contentdetailpbrg").html(msg)
        });  
        
    })



    // function detail permintaan barang
    // $(".btnmdludpbarang").click(function(){
    //     let id = $(this).attr('data')
    //     $.get("../../ajax/detailPermintaanBarang.asp?id="+ id, function(data){
    //         let x = data.split(",")
    //         $('#nbrg').val(x[0])
    //         $('#dbrgnama').val(x[1])
    //         $('#dspect').val(x[2])
    //         $('#dqtty').val(x[3])
    //         $('#dharga').val(x[4])
    //         $('#dsatuan').val(x[5])
    //         $('#dket').val(x[6])
    //         $('#dbrg').val(x[8])
    //     });
    // })

    // aktifasi header permintaan barang
    $('.btn-aktifpbarang').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete header barang",
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
    // aktifasi detail permintaan barang
    $('.btn-aktifdpbarang').click(function(e){
                    
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete barang",
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
