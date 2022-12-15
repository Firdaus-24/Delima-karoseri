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
})