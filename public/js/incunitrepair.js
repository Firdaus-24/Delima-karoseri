const getPenerimaanUnitByCabang = (e) => {
  $.post('getnomorpenerimaan.asp', { cabang: e }, function (data) {
    if (data != "") {
      $(".contentTblIncr").css({ "display": "block" })
      $(".contentTblIncr1").html(data)
    } else {
      $(".contentTblIncr").css({ "display": "none" })
      $(".contentTblIncr1").html('')
    }
  })
}

const setTfkIdIncr = (id, cust) => {
  let str = `${id.substring(0, 11)}/${id.substring(11, 15)}/${id.substring(15, 17)}/${id.substring(17, 20)}`
  $("#tfkid-incr").val(str)
  $("#customer-incomingunit").val(cust)
}


const getNameFileIncr = (val, id) => {
  let ekstensiOk = /(\.jpg|\.jpeg)$/i;

  if (val != "" && id == "imgIncrdA") {
    if (!ekstensiOk.exec(val)) {
      swal('Silakan upload file yang dengan ekstensi .jpeg/.jpg');
      $(`#${id}`).val('')
      return false;
    } else {
      $(".submitIncrdA").html(`<button type="submit" class="btn btn-light" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">
      Posting
      </button>`)

    }
  } else if (val != "" && id == "imgIncrdB") {
    if (!ekstensiOk.exec(val)) {
      swal('Silakan upload file yang dengan ekstensi .jpeg/.jpg');
      $(`#${id}`).val('')
      return false;
    } else {

      $(".submitIncrdB").html(`<button type="submit" class="btn btn-light" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">
      Posting
      </button>`)
    }
  } else if (val != "" && id == "imgIncrdC") {
    if (!ekstensiOk.exec(val)) {
      swal('Silakan upload file yang dengan ekstensi .jpeg/.jpg');
      $(`#${id}`).val('')
      return false;
    } else {
      $(".submitIncrdC").html(`<button type="submit" class="btn btn-light" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">
      Posting
      </button>`)
    }
  } else if (val != "" && id == "imgIncrdD") {
    if (!ekstensiOk.exec(val)) {
      swal('Silakan upload file yang dengan ekstensi .jpeg/.jpg');
      $(`#${id}`).val('')
      return false;
    } else {
      $(".submitIncrdD").html(`<button type="submit" class="btn btn-light" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">
      Posting
      </button>`)
    }
  } else if (val != "" && id == "imgIncrdE") {
    if (!ekstensiOk.exec(val)) {
      swal('Silakan upload file yang dengan ekstensi .jpeg/.jpg');
      $(`#${id}`).val('')
      return false;
    } else {
      $(".submitIncrdE").html(`<button type="submit" class="btn btn-light" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">
      Posting
      </button>`)
    }
  } else {
    $(".submitIncrdA").html('')
    $(".submitIncrdB").html('')
    $(".submitIncrdC").html('')
    $(".submitIncrdD").html('')
    $(".submitIncrdE").html('')
  }
}


// upload image detail
const uploadDetailIncrd = (val, idinp, idupload, idposting) => {
  let ekstensi = /(\.jpg|\.jpeg)$/i;
  if (val != '') {
    if (!ekstensi.exec(val)) {
      swal('Silakan upload file yang dengan ekstensi .jpeg/.jpg');
      $(`#${idinp}`).val('')
      $(`.${idupload}`).show()
      $(`.${idposting}`).hide()
      return false;
    } else {
      $(`.${idupload}`).hide()
      $(`.${idposting}`).show()
    }
  }
}

const sendEmailIncrepair = (e, id) => {
  $("#ajuanincrepair").val(e)
  $("#idincrepair").val(id)
}

