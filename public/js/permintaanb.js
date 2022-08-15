$(document).ready(function(){
    // get data barang
    $("#agenpb").change(function(){
        let agen = $("#agenpb").val()
        if(agen != ''){
            $.ajax({
                method: "POST",
                url: "../../ajax/getpermintaan.asp",
                data: { agen }
            }).done(function( msg ) {   
                $(".pbviewsal").hide()
                $(".pbviewhasil").html(msg)
            });
        }else{
            $(".pbviewsal").show()
            $(".pbviewhasil").html('')
        }
    })
    // update data update
    $("#agenpbu").change(function(){
        let agen = $("#agenpbu").val()
        
        if(agen != ''){
            $.ajax({
                method: "POST",
                url: "../../ajax/getpermintaan.asp",
                data: { agen }
            }).done(function( msg ) {   
                $(".pbviewusal").remove()
                $(".pbviewuhasil").html(msg)
            });
        }
    })
    // add barang
    $('.addBrg').click(function(){
        let clone = $( ".dpermintaan:first" ).clone()
        let last = $(".dpermintaan:last")
        clone.insertAfter(last)
        $(".dpermintaan:last #did").val('')
        $(".dpermintaan:last #brg").val('')
        $(".dpermintaan:last #spect").val('')
        $(".dpermintaan:last #qtty").val('')
        $(".dpermintaan:last #pbharga").val('')
        $(".dpermintaan:last #satuan").val('')
        $(".dpermintaan:last #ket").val('')
        
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

    // function detail permintaan barang
    $(".btnmdludpbarang").click(function(){
        let id = $(this).attr('data')
        $.get("../../ajax/detailPermintaanBarang.asp?id="+ id, function(data){
            let x = data.split(",")
            $('#nbrg').val(x[0])
            $('#dbrgnama').val(x[1])
            $('#dspect').val(x[2])
            $('#dqtty').val(x[3])
            $('#dharga').val(x[4])
            $('#dsatuan').val(x[5])
            $('#dket').val(x[6])
            $('#dbrg').val(x[8])
        });
    })

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
