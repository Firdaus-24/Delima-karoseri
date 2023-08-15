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
  $("#realHargaUprice").val(price);
  $("#ppnUpdateHargaPuchase").val(0);
  $("#hargaUpricePruchase").val("");
};

// hitung update harga purchase
const hitungUpricePurchase = () => {
  let realharga = $("#realHargaUprice").val();
  let ppn = $("#ppnUpdateHargaPuchase").val();
  let total;

  realharga = !realharga ? 0 : realharga.replace(/[.,-]/g, "");
  ppn = !ppn ? 0 : ppn;

  total =
    parseInt(realharga) +
    Math.round((parseInt(ppn) / 100) * parseInt(realharga));

  $("#hargaUpricePruchase").val(format(total));
};
