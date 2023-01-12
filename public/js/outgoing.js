$(document).ready(function(){
   // get nomor bom
   $("#agenOutgoing").change(function(){
      let cabang = $("#agenOutgoing").val()
      
      if(!cabang){
         $(".lbomlama").show()
     }else{
         $(".lbomlama").hide()
         $.ajax({
            method: "POST",
            url: "../../ajax/getNomorBomByCabang.asp",
            data: { cabang }
         }).done(function( msg ) {
            $(".lbombaru").html(msg)
         });
     }   
   })
   $("#cOutItem").keyup(function(){
      let nama = $("#cOutItem").val()
      let cabang = $("#cOutcabang").val()
      
      $.ajax({
         method: "POST",
         url: "../../ajax/getStokOutgoing.asp",
         data: { nama, cabang }
      }).done(function( msg ) {
         $(".contentItemsOutgoing").html(msg)
      });  
   })

})