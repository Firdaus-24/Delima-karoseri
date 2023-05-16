$(document).ready(function () {
  // cek tombol tambah
  $('.tambahusaha').click(function () {
    $('.titleusaha').html('FORM TAMBAH')
    $('.subusaha').html('Tambah')
    $('#initialush').val('add')
    $('#id').val('')
    $('#inpnama').val('')
  })
  // cek tombol update
  $('.updateusaha').click(function () {
    let id = $(this).attr('data')
    let nama = $(this).attr('valname')

    $('.titleusaha').html('FORM UPDATE')
    $('.subusaha').html('Update')
    $('#initialush').val('update')
    $('#id').val(id)
    $('#inpnama').val(nama)
  })

})