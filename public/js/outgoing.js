$(document).ready(function () {
  $("#cOutItem").keyup(function () {
    let nama = $("#cOutItem").val();
    let cabang = $("#cOutcabang").val();

    $.ajax({
      method: "POST",
      url: "../../ajax/getStokOutgoing.asp",
      data: { nama, cabang },
    }).done(function (msg) {
      $(".contentItemsOutgoing").html(msg);
    });
  });
});
const getCabangOutgoing = () => {
  return $("#agenOutgoing").val();
};

const getPdrOutgoing = (e) => {
  let cabang = getCabangOutgoing();
  let typeRadioPdr = e;
  if (!cabang) {
    $(".loutgoinglama")
      .html(`<select class="form-select" aria-label="Default select example" name="lbom" id="lbom" > 
                    <option value="" readonly disabled>Pilih Cabang dahulu</option>
                </select>`);
  } else if (!typeRadioPdr) {
    $(".loutgoinglama")
      .html(`<select class="form-select" aria-label="Default select example" name="lbom" id="lbom" > 
                    <option value="" readonly disabled>Pilih Cabang dahulu</option>
                </select>`);
  } else {
    $.ajax({
      method: "POST",
      url: "../../ajax/getpddpdrbycabang.asp",
      data: { cabang, typeRadioPdr },
    }).done(function (msg) {
      $(".loutgoinglama").html(msg);
    });
  }
};
