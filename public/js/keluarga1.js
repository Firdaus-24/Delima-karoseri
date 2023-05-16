const validasi = (form) => {
  var mincar = 30;
  var nama = document.forms["form-keluarga1"]["nama"].value;
  var tmptl = document.forms["form-keluarga1"]["tmptl"].value;
  if (nama.length > mincar) {
    alert("Maximal Nama 30 Karakter!!!");
    return false;
  }
  var tmptl = document.forms["form-keluarga1"]["tmptl"].value;
  if (tmptl.length > mincar) {
    alert("Maximal Tempat lahir 30 Karakter!!!");
    return false;
  }
  return true;
}
// tambahkeluarga1
const tambahkeluarga1 = () => {
  $('#labeltambahkeluarga1').html('TAMBAH KELUARGA1');
  $('.labeltambahkeluarga1').html('Tambah');
  $('.modal-body form').attr('action', 'keluarga1/tambah.asp');
  $('#nama').val("");
  $('#hubungan').val("Pilih");
  $('#tmptl').val("");
  $('#tgll').val("");
  $('#jkelamin').val("Pilih");
  // make function onchange
  $('#pendidikan').val("Pilih");
  $('#busaha').val("Pilih");
  $('#jabatan').val("Pilih");
  $('#skeluarga').val("Pilih");

  // ambil nama yang lama
  $('#namae').val("");

  input = $('#tgll');
  if (input.attr('type') == 'text') {
    input.attr('type', 'date');
  }
}
// ubah keluarga1
const ubahkeluarga = (id, nama) => {
  $.ajax({
    url: 'keluarga1/update.asp',
    data: { id: id, nama: nama },
    method: 'post',
    success: function (data) {
      function splitString(strToSplit, separator) {
        var arry = strToSplit.split(separator);
        // console.log(arry[6]);
        $('#nama').val(arry[1]);
        $('#namae').val(arry[1]);
        $('#hubungan').val(arry[2]);
        $('#hubungane').val(arry[2]);
        $('#tmptl').val(arry[3]);
        $('#tmptle').val(arry[3]);
        // $('#tgll').val(arry[4]);
        $('#tglle').val(arry[4]);
        $('#jkelamin').val(arry[5]);
        $('#jkelamine').val(arry[5]);
        $('#pendidikane').val(arry[6]);
        $('#busahae').val(arry[7]);
        $('#jabatane').val(arry[8]);
        $('#skeluargae').val(arry[9]);
        // make function onchange
        $('#pendidikan option[value=' + arry[6] + ']').prop("selected", true);
        $('#busaha option[value=' + arry[7] + ']').prop("selected", true);
        $('#jabatan option[value=' + arry[8] + ']').prop("selected", true);
        $('#skeluarga option[value=' + arry[9] + ']').prop("selected", true);

        input = $('#tgll');
        if (input.attr('type') == 'date') {
          input.attr('type', 'text');
          $('#tgll').val(arry[4]);
        } else {
          input.on('click', function () {
            input.attr('type', 'date');
          })
        }
      }
      const koma = ",";
      splitString(data, koma);
    }
  });
  $('#labeltambahkeluarga1').html('UPDATE KELUARGA1');
  $('.labeltambahkeluarga1').html('Update');
  $('.modal-body form').attr('action', 'keluarga1/update_add.asp');

}

function hapuskeluarga1(nip, nama, hub) {
  if (confirm("Yakin Untuk Di hapus") == true) {
    console.log(hub);
    return window.location = 'keluarga1/delete.asp?nip=' + nip + '&nama=' + nama + '&hub=' + hub
  } else {
    return false;
  }
}