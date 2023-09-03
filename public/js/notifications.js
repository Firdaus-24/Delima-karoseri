// notif anggaran inventory
const notifReqAnggaran = () => {
  let hasil = null;

  $.ajax({
    async: false,
    type: "get",
    global: false,
    url: `${window.location.origin}/views/notifications/appinventory_anggaran.asp`,
    success: function (data) {
      hasil = data;
    },
  });

  return hasil;
};
// notif voucher
const notifVoucher = () => {
  let hasil = null;

  $.ajax({
    async: false,
    type: "get",
    global: false,
    url: `${window.location.origin}/views/notifications/voucher_readyn.asp`,
    success: function (data) {
      hasil = data;
    },
  });

  return hasil;
};

// notif anggaran purchasing
const notifUpdateHargaPurchasing = () => {
  let hasilpurchase = null;

  $.ajax({
    async: false,
    type: "get",
    global: false,
    url: `${window.location.origin}/views/notifications/apppurchase_anggaran.asp`,
    success: function (data) {
      hasilpurchase = data;
    },
  });
  return hasilpurchase;
};
// notif anggaran fincance
const notifFinanceAnggaran = () => {
  let hasil = null;

  $.ajax({
    async: false,
    type: "get",
    global: false,
    url: `${window.location.origin}/views/notifications/finance_anggaran.asp`,
    success: function (data) {
      hasil = data;
    },
  });
  return hasil;
};
// notif sales order new
const notifSalesOrderNew = () => {
  let hasil = null;

  $.ajax({
    async: false,
    type: "get",
    global: false,
    url: `${window.location.origin}/views/notifications/salesordernew_produksi.asp`,
    success: function (data) {
      hasil = data;
    },
  });
  return hasil;
};

$(function () {
  // notif anggaran inventory
  notifReqAnggaran().MEMO != 0
    ? $(".notifReqAnggaranNavbar").html(notifReqAnggaran().MEMO)
    : $(".notifReqAnggaranNavbar").html("");
  notifReqAnggaran().REPAIR != 0
    ? $(".notifBomrepairNavbar").html(notifReqAnggaran().REPAIR)
    : $(".notifBomrepairNavbar").html("");
  notifReqAnggaran().PROJECT != 0
    ? $(".notifBomProjectNavbar").html(notifReqAnggaran().PROJECT)
    : $(".notifBomProjectNavbar").html("");
  // voucher permintaan barang
  notifVoucher().READYN != 0
    ? $(".notifVoucherNavbar").html(notifVoucher().READYN)
    : $(".notifVoucherNavbar").html("");

  // notif all inventory
  parseInt(notifReqAnggaran().MEMO) +
    parseInt(notifReqAnggaran().REPAIR) +
    parseInt(notifReqAnggaran().PROJECT) +
    parseInt(notifVoucher().READYN) !=
  0
    ? $(".notifInventoryNavbar").html(
        parseInt(notifReqAnggaran().MEMO) +
          parseInt(notifReqAnggaran().REPAIR) +
          parseInt(notifReqAnggaran().PROJECT) +
          parseInt(notifVoucher().READYN)
      )
    : $(".notifInventoryNavbar").html("");

  // notif update harga purchasing
  notifUpdateHargaPurchasing().APPPURCHASE != 0
    ? $(".notifUpdateHargaPurchaseNavbar").html(
        notifUpdateHargaPurchasing().APPPURCHASE
      )
    : $(".notifUpdateHargaPurchaseNavbar").html("");

  // notif all purchase
  notifUpdateHargaPurchasing().APPPURCHASE != 0
    ? $(".notifPurchaseNavbar").html(notifUpdateHargaPurchasing().APPPURCHASE)
    : $(".notifPurchaseNavbar").html("");

  // notif finance
  notifFinanceAnggaran().MEMO != 0
    ? $(".notifFinanceAnggaranNavbar").html(notifFinanceAnggaran().MEMO)
    : $(".notifFinanceAnggaranNavbar").html("");
  // notif all finance
  notifFinanceAnggaran().MEMO != 0
    ? $(".notifFinanceNavbar").html(notifFinanceAnggaran().MEMO)
    : $(".notifFinanceNavbar").html("");

  // notif produksi sales order new
  notifSalesOrderNew().SO != 0
    ? $(".notifSalesOrderNewNavbar").html(notifSalesOrderNew().SO)
    : $(".notifSalesOrderNewNavbar").html("");
  // notif all Produksi
  notifSalesOrderNew().SO != 0
    ? $(".notifProduksiNavbar").html(notifSalesOrderNew().SO)
    : $(".notifProduksiNavbar").html("");
});
