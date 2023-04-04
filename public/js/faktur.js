$(function () {
    // validasi tambah faktur
    $('#formfaktur').submit(function (e) {

        let form = this;

        e.preventDefault(); // <--- prevent form from submitting

        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "Faktur Terhutang",
            icon: "warning",
            buttons: [
                'No',
                'Yes'
            ],
            dangerMode: true,
        }).then(function (isConfirm) {
            if (isConfirm) {
                form.submit(); // <--- submit form programmatically
            } else {
                swal("Form gagal di kirim");
            }
        })
    })

    // aktifasi pruchase header
    $('.btn-fakturh').click(function (e) {

        e.preventDefault(); // <--- prevent click

        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete header faktur",
            icon: "warning",
            buttons: [
                'No',
                'Yes'
            ],
            dangerMode: true,
        }).then(function (isConfirm) {
            if (isConfirm) {
                window.location.href = e.target.href // <--- submit form programmatically
            } else {
                swal("Request gagal di kirim");
            }
        })
    })
    // aktifasi pruchase detail
    $('.btn-fakturd').click(function (e) {

        e.preventDefault(); // <--- prevent click

        swal({
            title: "YAKIN UNTUK DI HAPUS??",
            text: "delete detail faktur",
            icon: "warning",
            buttons: [
                'No',
                'Yes'
            ],
            dangerMode: true,
        }).then(function (isConfirm) {
            if (isConfirm) {
                window.location.href = e.target.href // <--- submit form programmatically
            } else {
                swal("Request gagal di kirim");
            }
        })
    })

    // get po by cabang
    $("#fakturagen").change(function () {
        let cabang = $("#fakturagen").val()
        if (cabang == "") {
            $(".lpobaru").hide()
            $(".lpolama").show()
        } else {
            $(".lpolama").hide()
            $.ajax({
                method: "POST",
                url: "../../ajax/getnopotofaktur.asp",
                data: { cabang }
            }).done(function (msg) {
                $(".lpobaru").html(msg)
            });
        }
    })
});