$(function(){
    // set value untuk disc1 dan disc2 jika kosong
    if (!$('input[name=disc1]').val()){
        $('input[name=disc1]').val(0)
    }
    if(!$('input[name=disc2]').val()){
        $('input[name=disc2]').val(0)
    }
    
    // cekbox 
    $(".ckpo").on("click", function() {
      var data = [];
      $("table > tbody > tr").each(function () {
        var $tr = $(this);
        if ($tr.find(".ckpo").is(":checked")) {
          data.push({
            item: $tr.find("#item").val(),
            qtty: $tr.find("#qtty").val(),
            harga: $tr.find("#hargapo").val(),
            satuan: $tr.find("#satuan").val(),
            disc1: $tr.find("#disc1").val(),
            disc2: $tr.find("#disc2").val()
          });
        }
      });      
      $("#valitem").val(data.map(el=>el.item).toString())
      $("#valqtty").val(data.map(el=>el.qtty).toString())
      $("#valharga").val(data.map(el=>el.harga).toString())
      $("#valsatuan").val(data.map(el=>el.satuan).toString())
      $("#valdisc1").val(data.map(el=>el.disc1).toString())
      $("#valdisc2").val(data.map(el=>el.disc2).toString())
      
    });

    // add barang
    $('.additempo').click(function(){
        let clone = $( ".dpurce:first" ).clone()
        let last = $(".dpurce:last")
        clone.insertAfter(last)
        $(".dpurce:last #itempo").val('')
        $(".dpurce:last #qttypo").val('')
        $(".dpurce:last #hargapo").val('')
        $(".dpurce:last #satuanpo").val('')
        $(".dpurce:last #dket").val('')
    })
    // delete barang
    $('.minitempo').click(function(){
        if ($(".dpurce").length > 1 ){
            $(".dpurce").last().remove()
        }
    })


    // validasi tambah pruchase
    $('#formpur').submit(function(e) {

        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        // checkbox
        if ($('.ckpo').filter(':checked').length < 1) {
            swal("Pilih Salah Satu Barang");
            return false;
        }else{
            swal({
                title: "APAKAH ANDA SUDAH YAKIN??",
                text: "Purchase Order",
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
        }
    })

    // validasi tambah pruchase
    $('#formpur1').submit(function(e) {

        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        // checkbox
        // if ($('.ckpo').filter(':checked').length < 1) {
        //     swal("Pilih Salah Satu Barang");
        //     return false;
        // }else{
            swal({
                title: "APAKAH ANDA SUDAH YAKIN??",
                text: "Purchase Order",
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
        // }
    })

    // aktifasi pruchase header
    $('.btn-purce1').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete header purchase",
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
    $('.btn-purce2').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete detail purchase",
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