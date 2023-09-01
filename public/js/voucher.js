const RemoveDesableVoucher = (e) => {
  if (e == "N") {
    $("#voucherAddpdhid").prop("disabled", false);
    $("#voucherAddpdrid").prop("disabled", true);
    $("#voucherAddpdrid").val("");
  } else {
    $("#voucherAddpdrid").prop("disabled", false);
    $("#voucherAddpdhid").prop("disabled", true);
    $("#voucherAddpdhid").val("");
  }
  return;
};

const getBarangVoucher = (nama, htmlclass) => {
  if (!nama) {
    $.ajax({
      method: "POST",
      url: "getbarang.asp",
      dataType: "html",
      success: function (data) {
        htmlclass.html(data);
        return data;
      },
      error: function () {
        alert("Ada yang salah nih!");
      },
    });
  } else {
    $.ajax({
      method: "POST",
      url: "getbarang.asp",
      data: { nama },
      dataType: "html",
      success: function (data) {
        htmlclass.html(data);
        return data;
      },
      error: function () {
        alert("Ada yang salah nih!");
      },
    });
  }
  // return;
};
// tambah voucher
const tambahVoucherPermintaanBarang = () => {
  getBarangVoucher("", $(".contentBrgVoucherdAdd"));
  $("#cpbarangVoucher").val("");
  $("input:radio[name=ckbrgvoucherPBarang]").prop("checked", false);
  $("#qttyVoucherpBarang").val(0);
  $("#satuanVoucherpBarang").val("");
  $("#keteranganVoucherpbarang").val("");
};

// cari barang di voucher
const cpBrgVoucherD = (e) => {
  getBarangVoucher(e, $(".contentBrgVoucherdAdd"));
};
