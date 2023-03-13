$(document).ready(function () {
  // cek tombol tambah
  $('.tambahpanjang').click(function () {
    $('#formsatuanpanjang').attr('action', 'sat_add.asp')
    $('.tbn-submit-satuanpanjang').html('Tambah')
    $('#id').val('')
    $('#inpnama').val('')
  })
  // cek tombol update
  $('.updateSatuanPanjang').click(function () {
    let id = $(this).attr('data')
    let nama = $(this).attr('valname')

    $('#formsatuanpanjang').attr('action', 'sat_u.asp')
    $('.tbn-submit-satuanpanjang').html('Update')
    $('#id').val(id)
    $('#inpnama').val(nama)
  })


})