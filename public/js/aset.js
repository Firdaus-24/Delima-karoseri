$(document).ready(function () {
  // get get departement
  $("#divisi").change(function () {
    const divisi = $("#divisi").val();
    if (!divisi) {
      $(".asetdeplama").show();
    } else {
      $(".asetdeplama").hide();
      $.ajax({
        method: "POST",
        url: "../../ajax/getdepartement.asp",
        data: { divisi },
      }).done(function (msg) {
        $(".asetdepbaru").html(msg);
      });
    }
  });

  // tambah detail penjualan
  $("#formaset").submit(function (e) {
    let form = this;
    let qtyaset = Number($("#qtyaset").val());
    let jqtyaset = Number($("#jqtyaset").val());

    e.preventDefault(); // <--- prevent form from submitting

    if (qtyaset > jqtyaset) {
      swal("Permintaan Melebihi stok");
      return false;
    } else {
      swal({
        title: "APAKAH ANDA SUDAH YAKIN??",
        text: "Tambah Aset",
        icon: "warning",
        buttons: ["No", "Yes"],
        dangerMode: true,
      }).then(function (isConfirm) {
        if (isConfirm) {
          form.submit(); // <--- submit form programmatically
        } else {
          swal("Form gagal di kirim");
        }
      });
    }
  });

  // content tbody
  $(".contentdetailAset").html(function () {
    let cabang = $("#asetcabang").val();

    $.ajax({
      method: "POST",
      url: "../../ajax/getBarangAset.asp",
      data: { cabang },
    }).done(function (msg) {
      $(".loaderjual img").hide();
      $(".contentdetailAset").html(msg);
    });
  });

  // cari barang pembelian
  $("#cbrgaset").keyup(function () {
    $(".loaderaset img").show();
    let nama = $("#cbrgaset").val().toUpperCase();
    let cabang = $("#asetcabang").val();

    $.ajax({
      method: "POST",
      url: "../../ajax/getBarangAset.asp",
      data: { nama, cabang },
    }).done(function (msg) {
      $(".loaderaset img").hide();
      $(".contentdetailAset").html(msg);
    });
  });
});

function setBarangAset(e) {
  $("#jqtyaset").val(e);
  $("#qtyaset").val("");
}
