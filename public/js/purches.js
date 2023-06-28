$(function () {
  // set value untuk disc1 dan disc2 jika kosong
  if (!$("input[name=disc1]").val()) {
    $("input[name=disc1]").val(0);
  }
  if (!$("input[name=disc2]").val()) {
    $("input[name=disc2]").val(0);
  }

  // get value radio po form tambah
  $("#formaddpo input").on("change", function () {
    let ckpobrg = $("input[name=ckbrgpo]:checked", "#formaddpo")
      .val()
      .split(",");
    const myArray = ckpobrg[1];

    $("#hargapo").val(
      parseFloat(myArray.replace(/,/g, ""))
        .toFixed(2)
        .toString()
        .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    );
  });
  // get value radio po form update
  $("#formupdatepo input").on("change", function () {
    let ckpobrg = $("input[name=ckbrgpo]:checked", "#formupdatepo")
      .val()
      .split(",");
    const myArray = ckpobrg[1];

    $("#hargaupo").val(
      parseFloat(myArray.replace(/,/g, ""))
        .toFixed(2)
        .toString()
        .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    );
  });

  // aktifasi pruchase header
  $(".btn-purce1").click(function (e) {
    e.preventDefault(); // <--- prevent click

    swal({
      title: "YAKIN UNTUK DI HAPUS??",
      text: "delete header purchase",
      icon: "warning",
      buttons: ["No", "Yes"],
      dangerMode: true,
    }).then(function (isConfirm) {
      if (isConfirm) {
        window.location.href = e.target.href; // <--- submit form programmatically
      } else {
        swal("Request gagal di kirim");
      }
    });
  });
  // aktifasi pruchase detail
  $(".btn-purce2").click(function (e) {
    e.preventDefault(); // <--- prevent click

    swal({
      title: "YAKIN UNTUK DI HAPUS??",
      text: "delete detail purchase",
      icon: "warning",
      buttons: ["No", "Yes"],
      dangerMode: true,
    }).then(function (isConfirm) {
      if (isConfirm) {
        window.location.href = e.target.href; // <--- submit form programmatically
      } else {
        swal("Request gagal di kirim");
      }
    });
  });

  // update harga memo
  // $(".modalUpdateHarga").click(function(){
  //     let dataID = $(this).attr("data-iddetail")
  //     $.ajax({
  //         method: "POST",
  //         url: "../../ajax/getDetailPermintaan.asp",
  //         data: { id:dataID }
  //     }).done(function( msg ) {
  //         $("#memoiddetail").val(msg[0].MEMOID.toString())
  //         $("#brgUMemo").val(msg[0].BARANGNAMA.toString())
  //         $("#spectUMemo").val(msg[0].SPECT.toString())
  //         $("#qttyUMemo").val(msg[0].QTTY.toString())
  //         $("#satuanUMemo").val(msg[0].SATUANNAMA.toString())
  //         $("#ketUMemo").val(msg[0].KETERANGAN.toString())
  //         $("#hargaumemo").val(msg[0].HARGA.toString())
  //     });

  // })

  // getdata id memo
  $("#agenPotoMemo").change(function () {
    let cabang = $("#agenPotoMemo").val();
    let request = $.ajax({
      url: "../../ajax/getMemoHeader.asp",
      method: "POST",
      data: { cabang },
      dataType: "html",
    });

    request.done(function (msg) {
      $(".tampilPoTomemo").html(msg);
    });

    request.fail(function (jqXHR, textStatus) {
      alert("Request failed: " + textStatus);
    });
  });
});

const getUpricePurchase = (id, brgnama, spec, qty, satuan, ket, price) => {
  $("#memoiddetail").val(id);
  $("#brgUMemo").val(brgnama);
  $("#spectUMemo").val(spec);
  $("#qttyUMemo").val(qty);
  $("#satuanUMemo").val(satuan);
  $("#ketUMemo").val(ket);
  $("#hargaumemo").val(price);
};
