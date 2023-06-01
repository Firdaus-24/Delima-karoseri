$(document).ready(function () {
  $("#materialcabang").change(function () {
    let cabang = $("#materialcabang").val()
    $.post("../../ajax/getMaterialReturnProduksi.asp", { cabang }, function (data) {
      $("#prodMaterial").html(data);
    });
  })

  // cari nama barang return material
  $("#cariRM").keyup(function () {
    let namaReturnMaterial = $("#cariRM").val()
    let pdhidrm = $("#pdhidrm").val()

    $.post("../../ajax/getNamaMaterialReturn.asp", { namaReturnMaterial, pdhidrm }, function (data) {
      if (data.length > 0) {
        $(".contentRM").html(data);
      } else {
        $(".contentRM").html(`<div style="display:flex;widht:100%;text-align:center;color:red"><H5>DATA TIDAK TERDAFTAR</H5></div>`);
      }
    })
  })
})

const getHargaRC = (item, qty) => {
  $("#nqty").val(qty)
  $.post("./getharga.asp", { item }, function (data) {
    $("#hargaRC").val(format(data))
  })
}

const validasiReturnMaterial = (data, e) => {
  // let stok = parseInt($("#nqty").val())
  // let qty = parseInt($("#qtty").val())

  let form = data;
  e.preventDefault(); // <--- prevent form from submitting

  swal({
    title: "APAKAH ANDA SUDAH YAKIN??",
    text: "detail return material sisa produksi",
    icon: "warning",
    buttons: [
      'No',
      'Yes'
    ],
    dangerMode: true,
  }).then(function (isConfirm) {
    if (isConfirm) {
      // if (stok < qty) {
      //   swal("Permintaan yang anda masukan melebihi quantity");
      //   return false
      // }
      form.submit(); // <--- submit form programmatically
    } else {
      swal("Form gagal di kirim");
    }
  })
}