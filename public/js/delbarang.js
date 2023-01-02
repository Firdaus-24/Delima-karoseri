$(document).ready(function(){
    $("#delbrg").keyup(function(){
        const cabang = $("#cbgDelBarang").val()
        const nama = $("#delbrg").val()
        
        if(cabang === ""){
            swal("Pilih Cabang Dahulu")
            $("#delbrg").val('')
            return false
        }
        if(nama.length <= 0){
            $(".TblDelBarang").html('')
        }else{
            $.ajax({
                method: "POST",
                url: "../../ajax/getdelbarang.asp",
                data: { nama, cabang }
            }).done(function( msg ) {
                $(".TblDelBarang").html(msg)
            });  
        }
    })

    $("#formDelBarang").submit(function(e){
        e.preventDefault();
        let form = this
        
        let qtylama = Number($("#qtystokdelbrg").val())
        let qtybaru = Number($("#qty").val())

        if (qtybaru > qtylama){
            swal("Permintaan Melebihi Stok");
            return false
        }
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "FORM TAMBAH BARANG RUSAK",
            icon: "warning",
            buttons: [
            'No',
            'Yes'
            ],
            dangerMode: true,
        }).then(function(isConfirm) {
            if (isConfirm) {
                form.submit(); // <--- submit form programmatically
            } else {
            swal("Form gagal di kirim");
            }
        })  
    })
})
function getBrgDelete(id,nama,qty, satuan,harga){
    console.log(satuan);
    
    $("#delbrg").val(nama)
    $("#delbrgid").val(id)
    $("#qtystokdelbrg").val(qty)
    $("#satuan").val(satuan)
    $("#harga").val(harga)
    $(".TblDelBarang").html('')
}