$(document).ready(function(){
    $("#returncabang").change(function(){
        let returncabang = $("#returncabang").val()
        
        if (returncabang == ""){
            $(".vendorlama").show()
            $(".vendorbaru").hide()
        }else{
            $(".vendorlama").hide()
            $(".vendorbaru").show()
            $.ajax({
                method: "POST",
                url: "../../ajax/getVendorByCabang.asp",
                data: { cabang:returncabang }
            }).done(function( msg ) {
                $(".vendorbaru").html(msg)
            });  
        }
    })
})