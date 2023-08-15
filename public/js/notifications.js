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

  // notif all inventory
  parseInt(notifReqAnggaran().MEMO) +
    parseInt(notifReqAnggaran().REPAIR) +
    parseInt(notifReqAnggaran().PROJECT) !=
  0
    ? $(".notifInventoryNavbar").html(
        parseInt(notifReqAnggaran().MEMO) +
          parseInt(notifReqAnggaran().REPAIR) +
          parseInt(notifReqAnggaran().PROJECT)
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
});
