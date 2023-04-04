$(function () {
  // get data sales order dan nomor produksi
  $("#cabangPdi").change(function () {
    let cabang = $("#cabangPdi").val()

    if (cabang !== "") {
      // untuk nomor produksi
      $.post("getnoproduksi.asp", { cabang }, function (data) {
        $(".pdiprodlama").html(data)
      })

      // untuk sales order
      $.post("getsalesorder.asp", { cabang }, function (msg) {
        $(".pdiojhid").html(msg)
      })
    } else {
      // untuk nomor produksi
      $(".pdiprodlama").html(` <select class="form-select" aria-label="Default select example" name="pdiprod" id="pdiprod"><option value="" readonly disabled>Pilih Cabang dahulu</option></select>`)

      // untuk sales order
      $(".pdiojhid").html(`<select class="form-select" aria-label="Default select example" name="noso" id="noso" > 
      <option value="" readonly disabled>Pilih Cabang dahulu</option></select>`)
    }
  })



});