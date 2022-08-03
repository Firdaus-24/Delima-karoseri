$(function(){
    // set value untuk disc1 dan disc2 jika kosong
    $('input[name=disc1]').val(0)
    $('input[name=disc2]').val(0)
    
    // cekbox 
    $(".ckpo").on("click", function() {
      var data = [];
      $("table > tbody > tr").each(function () {
        var $tr = $(this);
        if ($tr.find(".ckpo").is(":checked")) {
          data.push({
            item: $tr.find("#item").val(),
            qtty: $tr.find("#qtty").val(),
            harga: $tr.find("#harga").val(),
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


    // validasi tambah rak
    $('#formpur').submit(function(e) {

        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
      
        // checkbox
        // if ($('.ckpo').filter(':checked').length < 1) {
        //     swal("Pilih Salah Satu Barang");
        //     return false;
        // }else{
            swal({
                title: "APAKAH ANDA SUDAH YAKIN??",
                text: "form tambah P.O",
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

});