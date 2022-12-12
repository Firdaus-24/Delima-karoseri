$(document).ready(function(){
   // get all product
   $("#bomagen").change(function(){
      let agen = $("#bomagen").val()

      if(!agen){
         $(".lproductlama").show()
      }else{
         $(".lproductlama").hide()
         $.ajax({
            method: "POST",
            url: "../../ajax/getallproduk.asp",
            data: { agen }
         }).done(function( msg ) {
            $(".lproductbaru").html(msg)
         });
      }     
   })
})