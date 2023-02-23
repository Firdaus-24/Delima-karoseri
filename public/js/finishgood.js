$(function () {

   $('#agenFinishGood').change(function () {
      let agen = $('#agenFinishGood').val()
      $.post("getNoProduksi.asp", { agen }, function (data) {
         $("#pdhidFinishGood").html(data)
      });
   })
})