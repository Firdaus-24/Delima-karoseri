function validasiForm(data, e, te, ic){
    let form = data;
    e.preventDefault(); // <--- prevent form from submitting
   
    swal({
        title: "APAKAH ANDA SUDAH YAKIN??",
        text: te,
        icon: ic,
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

function deleteItem(e,tex){
    e.preventDefault(); // <--- prevent click
    
    swal({
        title: "YAKIN UNTUK DI HAPUS??",
        text: tex,
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
}

function printIt(url) {
    var wnd = window.open(url);
    wnd.print();
}

function generateQrcode(urlId){
    let finalURL ='https://chart.googleapis.com/chart?cht=qr&chl=' + htmlEncode(urlId) + '&chs=160x160&chld=L|0'

    return finalURL 
}
function formatRupiah(number){
    var rupiah = '';
    var angkarev = number.toString().split('').reverse().join('');
    for (var i = 0; i < angkarev.length; i++) if (i % 3 === 0) rupiah += angkarev.substr(i, 3) + '.';
        return rupiah.split('', rupiah.length - 1).reverse().join('') + ',-';
}
