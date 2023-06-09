const getincommingunitpdr = (id,cabang) => {
  $.ajax({
    method: "POST",
    url: "getincommingunit.asp",
    data: { cabang }
  }).done(function (msg) {
    return $(`#${id}`).html(msg)
  });
}

const getdetailincommingunitpdr = (irhid,id1,id2,id3,id4,id5,id6,id7,id8) => {
  $.ajax({
    method: "POST",
    url: "getdetailincommingunit.asp",
    data: { irhid }
  }).done(function (msg) {
    $(`#${id1}`).val(msg[0].TFKID)
    $(`#${id2}`).val(msg[0].BRANDID)
    $(`#${id3}`).val(msg[0].BRANDNAME)
    $(`#${id4}`).val(msg[0].TYPE)
    $(`#${id5}`).val(msg[0].NOPOL)
    $(`#${id6}`).val(msg[0].MESIN)
    $(`#${id7}`).val(msg[0].RANGKA)
    $(`#${id8}`).val(msg[0].WARNA)
    return
  });
}
// form tambah
$("#cabangpdr").change(function () {
    let cabang = $("#cabangpdr").val()
    if (!cabang) {
      $("#irhidrepair").html(`<option value="" readonly disabled>Pilih Cabang dahulu</option>`)
    } else {
      getincommingunitpdr('irhidrepair', cabang)
    }
})
$("#irhidrepair").change(function () {
  let irhid = $("#irhidrepair").val()

    getdetailincommingunitpdr(irhid, 'tfkidpdr', 'brandidpdr', 'brandnamepdr', 'typepdr', 'nopolpdr', 'nomesinpdr', 'rangkapdr', 'warnapdr')
})

// form update
$("#cabangpdru").change(function () {
    let cabang = $("#cabangpdru").val()

    if (!cabang) {
      $("#irhidrepairupdate").html(`<option value="" readonly disabled>Pilih Cabang dahulu</option>`)
    } else {
      getincommingunitpdr('irhidrepairupdate', cabang)
    }
})

$("#irhidrepairupdate").change(function () {
    let irhid = $("#irhidrepairupdate").val()

    getdetailincommingunitpdr(irhid, 'tfkidpdru', 'brandidpdru', 'brandnamepdru', 'typepdru', 'nopolpdru', 'nomesinpdru', 'rangkapdru', 'warnapdru')
})