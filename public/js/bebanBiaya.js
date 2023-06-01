$(document).ready(function () {
  // cek tombol tambah
  $('.tambahBebanBiaya').click(function () {
    $('.titBebanBiaya').html('FORM TAMBAH')
    $('#formBebanBiaya').attr('action', 'bn_add.asp')
    $('.subBB').html('Tambah')
    $('#id').val('')
    $('#bnNama').val('')
  })
  // cek tombol update
  $('.updatebebanBiaya').click(function () {
    let id = $(this).attr('data')
    let nama = $(this).attr('valname')

    $('.titBebanBiaya').html('FORM UPDATE')
    $('#formBebanBiaya').attr('action', 'bn_u.asp')
    $('.subBB').html('Update')
    $('#id').val(id)
    $('#bnNama').val(nama)
  })
})