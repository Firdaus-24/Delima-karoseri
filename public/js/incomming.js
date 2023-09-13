const getVendorMR = (id) => {
  $.post("getvendor.asp", { id }, function (data) {
    $("#venidmr").val(data.ID);
    $("#venname").val(data.NAMA);
  });
};

let sisaQtyPoToMr = null;
const ckSisaQtyMr = (sisa) => {
  sisaQtyPoToMr = sisa;
  return sisaQtyPoToMr;
};

const validasiFormIncomming = (data, e, te, ic) => {
  let form = data;
  e.preventDefault(); // <--- prevent form from submitting

  if (parseInt(sisaQtyPoToMr) < parseInt(form["qtyincomed"].value)) {
    swal("Error!", "Quantity melebihi batas", "error");
    return false;
  }
  swal({
    title: "APAKAH ANDA SUDAH YAKIN??",
    text: te,
    icon: ic,
    buttons: ["No", "Yes"],
    dangerMode: true,
  }).then(function (isConfirm) {
    if (isConfirm) {
      form.submit(); // <--- submit form programmatically
    } else {
      swal("Form gagal di kirim");
    }
  });
};
