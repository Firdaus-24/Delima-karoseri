$(document).ready(function(){
    let orjulagen
    // get departement 
    $("#orjuldivisi").change(function(){
        const divisi = $("#orjuldivisi").val()
        if(!divisi){
            $(".orjuldeplama").show()
            $(".orjuldepbaru").hide()
        }else{
            $(".orjuldeplama").hide()
            $.post("../../ajax/getdepartement.asp", {divisi}, function(result){
                $(".orjuldepbaru").show()
                $(".orjuldepbaru").html(result)
            });
        }
    })
    // get agen id
    $("#orjulagen").change(function(){
        orjulagen = $("#orjulagen").val()
    })

    // get nomor produksi
    $("#orjulkebutuhan").change(function(){
        let agen = orjulagen
        let kebutuhan = parseInt($("#orjulkebutuhan").val())

        if (kebutuhan == 0){
            
            if (!agen){
                swal({text:"Pilih agen dulu ya",icon:"warning"})
                $("#orjulkebutuhan").val("")
                $(".lproduk").show()
            }else{
                $(".lproduk").hide()
                
                $.post("../../ajax/getallproduk.asp", {agen}, function(result){
                    $(".cariProduk").html(result)
                });
            }
        }else{
            $(".lproduk").show()
            $(".cariProduk").html('')
        }
    })

    // cari barang by agen dan nama
    $("#cporjulbarang").keyup(function(){
        let nama = $("#cporjulbarang").val()
        let cabang = $("#ojhagenid").val()

        if (nama.length > 0 ){
            $(".contentorjullama").hide()
            
            $.ajax({
                method: "POST",
                url: "../../ajax/getbarangbycabang.asp",
                data: { nama, cabang }
            }).done(function( msg ) {
                $(".contentOrjulbarang").html(msg)
            });  
        }else{
            $(".contentorjullama").show()
            $(".contentOrjulbarang").html('')
        }
        
    })
})