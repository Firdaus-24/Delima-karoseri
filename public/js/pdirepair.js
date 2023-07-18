const getDepPdiRepair = (id) => {
  let divisi = id;
  if (divisi != "") {
    $.post("../../ajax/getDepartement.asp", { divisi }, function (data) {
      $(".pdiDepartementRepair").html(data);
    });
  } else {
    $(".pdiDepartementRepair").html(
      `<select class="form-select" aria-label="Default select example" id="depPdi" name="deppdi"><option value="" readonly disabled>Pilih Divisi dahulu</option></select>`
    );
  }
};

const getPDIProRepair = (cabang) => {
  if (cabang != "") {
    $.post("getprodrepair.asp", { cabang }, function (data) {
      $(".pdiprodrepair").html(data);
    });
  } else {
    $(".pdiprodrepair").html(
      `<select class="form-select" aria-label="Default select example" id="pdiprodrepair" name="pdiprodrepair"><option value="" readonly disabled>Pilih Cabang dahulu</option></select>`
    );
  }
};

const getDatailPdiProdRepair = (id) => {
  if (id != "") {
    $.ajax({
      method: "POST",
      url: "getproddetail.asp",
      data: { id },
      error: function (xhr, status, error) {
        var err = eval("(" + xhr.responseText + ")");
        alert(err.Message);
      },
      success: function (msg) {
        if (msg[0].ERROR) {
          alert(msg[0].ERROR);
        } else {
          $("#tfkidpdirepair").val(msg[0].TFKID);
          $("#irhidpdirepair").val(msg[0].IRHID);
          $("#brandidpdirepair").val(msg[0].BRANDID);
          $("#brandname").val(msg[0].BRANDNAME);
          $("#typepdirepair").val(msg[0].TYPE);
          $("#nopolpdirepair").val(msg[0].NOPOL);
          $("#rankapdirepair").val(msg[0].RANGKA);
          $("#mesinpdirepair").val(msg[0].MESIN);
          $("#warnapdirepair").val(msg[0].WARNA);
        }
      },
    });
  } else {
    $(".pdridrepair").html(
      `<option value="" readonly disabled>Pilih Cabang dahulu</option></select>`
    );
  }
  return false;
};
// form tambah
const PdiRepairAdd = () => {
  $("#idpdirdrepair").val("");
  $(".getImgIrdIrhid").html("<div class='imgpdir skeleton'></div>");
  $("#initupdate").val("");
  $("#irdirhid").val("");
  $(".pdirIrdIrhid").hide();
  $("#pdiRepairdesc").val("");
  $("#pdiRepairremaks").val("");
  $("input[name='conditionPdiRepair']").prop("checked", false);
};
// form Update
const PdiRepairUpdate = (
  id,
  irhid,
  desc,
  condition,
  pathimg,
  pathnophoto,
  remaks
) => {
  $("#idpdirdrepair").val(id);
  $("#irdirhid").val(irhid);
  if (irhid != "") {
    $(".pdirIrdIrhid").show();
    $.ajax({
      type: "get",
      url: `${pathimg}.jpg`,
      statusCode: {
        400: function (response) {
          setTimeout(function () {
            $(".getImgIrdIrhid").html(
              `<img src=${pathnophoto}.jpg class="imgpdir">`
            );
          }, 1000);
        },
        404: function (response) {
          setTimeout(function () {
            $(".getImgIrdIrhid").html(
              `<img src=${pathnophoto}.jpg class="imgpdir">`
            );
          }, 1000);
        },
      },
      success: (data) => {
        setTimeout(function () {
          $(".getImgIrdIrhid").html(`<img src=${pathimg}.jpg class="imgpdir">`);
        }, 2000);
      },
    });
  } else {
    $(".pdirIrdIrhid").hide();
    $(".getImgIrdIrhid").html(`<div class='imgpdir skeleton'></div>`);
  }
  $("#pdiRepairdesc").val(desc);
  $("#pdiRepairremaks").val(remaks);
  $("input[name='conditionPdiRepair'][value=" + condition + "]").prop(
    "checked",
    true
  );
};

// form upload image detail
const uploadDetailpdirepair = (val, idinp, idupload, idposting) => {
  let ekstensi = /(\.jpg|\.jpeg)$/i;
  if (val != "") {
    if (!ekstensi.exec(val)) {
      swal("Silakan upload file yang dengan ekstensi .jpeg/.jpg");
      $(`#${idinp}`).val("");
      $(`.${idupload}`).show();
      $(`.${idposting}`).hide();
      return false;
    } else {
      $(`#${idinp}`).css("z-index", "-1");
      $(`.${idupload}`).hide();
      $(`.${idposting}`).show();
      return false;
    }
  }
};
// upload image pdirepair
const getImgIrdIrhID = (path, val) => {
  $(".pdirIrdIrhid").show();
  $(".imgpdir").addClass("skeleton");
  $.ajax({
    type: "get",
    url: `${path}${val}.jpg`,
    statusCode: {
      400: function (response) {
        $(".pdirIrdIrhid").hide();
        swal({
          title: "ERROR",
          text: "gambar belum terupload",
          icon: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes!",
        });
      },
      404: function (response) {
        $(".pdirIrdIrhid").hide();
        swal({
          title: "ERROR",
          text: "gambar belum terupload",
          icon: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes!",
        });
      },
    },
    success: (data) => {
      setTimeout(function () {
        $(".getImgIrdIrhid").html(
          `<img src=${path}${val}.jpg class="imgpdir">`
        );
      }, 2000);
    },
  });
  return;
};

// update condition pdirepair
const ckPdiRepairDesc = (id, type) => {
  $.ajax({
    type: "post",
    url: "desc_u.asp",
    data: { id, type },
    success: (data) => {
      if (data) {
        swal({
          title: "PERHATIAAN!!!",
          text: data,
          icon: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes",
        }).then((isConfirm) => {
          window.location.reload();
        });
      }
    },
  });
  return;
};
