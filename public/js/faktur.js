$(function(){
    // set value untuk disc1 dan disc2 jika kosong
    // if (!$('input[name=disc1]').val()){
    //     $('input[name=disc1]').val(0)
    // }
    // if(!$('input[name=disc2]').val()){
    //     $('input[name=disc2]').val(0)
    // }
    
    // cekbox 
    // $(".ckpo").on("click", function() {
    //   var data = [];
    //   $("table > tbody > tr").each(function () {
    //     var $tr = $(this);
    //     if ($tr.find(".ckpo").is(":checked")) {
    //       data.push({
    //         item: $tr.find("#item").val(),
    //         qtty: $tr.find("#qtty").val(),
    //         harga: $tr.find("#hargapo").val(),
    //         satuan: $tr.find("#satuan").val(),
    //         disc1: $tr.find("#disc1").val(),
    //         disc2: $tr.find("#disc2").val()
    //       });
    //     }
    //   });      
    //   $("#valitem").val(data.map(el=>el.item).toString())
    //   $("#valqtty").val(data.map(el=>el.qtty).toString())
    //   $("#valharga").val(data.map(el=>el.harga).toString())
    //   $("#valsatuan").val(data.map(el=>el.satuan).toString())
    //   $("#valdisc1").val(data.map(el=>el.disc1).toString())
    //   $("#valdisc2").val(data.map(el=>el.disc2).toString())
      
    // });

    // add barang
    $('.addfaktur').click(function(){
        let clone = $( ".dfaktur:first" ).clone()
        let last = $(".dfaktur:last")
        clone.insertAfter(last)
        $(".dfaktur:last #itempo").val('')
        $(".dfaktur:last #qttypo").val('')
        $(".dfaktur:last #hargapo").val('')
        $(".dfaktur:last #satuanpo").val('')
        $(".dfaktur:last #dket").val('')
    })
    // delete barang
    $('.minfaktur').click(function(){
        if ($(".dfaktur").length > 1 ){
            $(".dfaktur").last().remove()
        }
    })


    // validasi tambah faktur
    $('#formfaktur').submit(function(e) {

    let form = this;
    
    e.preventDefault(); // <--- prevent form from submitting
    
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "Faktur Terhutang",
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

    // aktifasi pruchase header
    $('.btn-fakturh').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete header faktur",
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
    // aktifasi pruchase detail
    $('.btn-fakturd').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete detail faktur",
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


});