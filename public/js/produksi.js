$(document).ready(function () {
  $("#salesOrderProduksi").change(function () {
    let id = $(this).val();
    $.ajax({
      method: "GET",
      url: "getdetailsonew.asp",
      data: { id },
      statusCode: {
        500: function () {
          alert("Nomor Tidak Terdaftar");
        },
      },
    }).done(function (msg) {
      $(".contentDetailSoProduksi").html(msg);
    });
  });
});
