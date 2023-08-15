$(document).ready(function () {
  // getdepartement
  $("#pbdivisi").change(function () {
    let divisi = $("#pbdivisi").val();

    if (!divisi) {
      $(".deplama").show();
    } else {
      $(".deplama").hide();
      $.ajax({
        method: "POST",
        url: "getdep.asp",
        data: { divisi },
      }).done(function (msg) {
        $(".depbaru").html(msg);
      });
    }
  });

  // aktifasi header permintaan barang
  $(".btn-aktifpbarang").click(function (e) {
    e.preventDefault(); // <--- prevent click

    swal({
      title: "YAKIN UNTUK DI HAPUS??",
      text: "delete header barang",
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
  // aktifasi detail permintaan barang
  $(".btn-aktifdpbarang").click(function (e) {
    e.preventDefault(); // <--- prevent click

    swal({
      title: "YAKIN UNTUK DI HAPUS??",
      text: "delete barang",
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
});
