$(document).ready(function(){
    // get barang by agen
    $("#produkcabang").change(function(){
        let cabang = $("#produkcabang").val()
        
        if(!cabang){
            $("#produkbrg").show()
        }else{
            $("#produkbrg").hide()
            $.ajax({
                method: "POST",
                url: "../../ajax/getbarangbycabang.asp",
                data: { cabang }
            }).done(function( msg ) {
                $(".produkbrg").html(msg)
            });
        }
    })

})