$(document).ready(function(){
    // validasi tambah satuan
    $('#formorjul').submit(function(e) {
        let form = this;
        
        e.preventDefault(); // <--- prevent form from submitting
        
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "Order Penjualan Customer",
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

    // aktifasi sat
    $('.btn-orjual').click(function(e){
        
        e.preventDefault(); // <--- prevent click
        
        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "Delete Order Penjualan",
            icon: "warning",
            buttons: [
              'No',
              'Yes'
            ],
            dangerMode: true,
        }).then(function(isConfirm) {
            if (isConfirm) {
                window.location.href = e.target.href // <--- submit form programmatically
            } else {
              swal("Request gagal di kirim");
            }
        })
    })

    // get stok barang
    $("input[name='ckdorjul']").change(function(){
        const str =  $("input[name='ckdorjul']:checked").val()
        const pieces = str.split(/[\s,]+/)
        const last = pieces[pieces.length - 1]
        $("#fqty").val(last)       
        $("#qtyorjul").val('')
    })

    $('#rincianOrjul').submit(function(e) {
        let form = this;
        let fqty = Number($("#fqty").val())
        let qtyorjul = Number($("#qtyorjul").val())

        e.preventDefault(); // <--- prevent form from submitting

        if (qtyorjul > fqty){
            swal("Permintaan Melebihi stok");
            return false
        }else{
            swal({
                title: "APAKAH ANDA SUDAH YAKIN??",
                text: "Order Rincian Barang",
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
        }
    })

})