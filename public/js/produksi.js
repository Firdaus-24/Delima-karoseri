$(document).ready(function () {
    $("#prodagen").change(function () {
        let agen = $("#prodagen").val()

        if (!agen) {
            $(".lproductlama").show()
        } else {
            $(".lproductlama").hide()
            $.ajax({
                method: "POST",
                url: "../../ajax/getallbom.asp",
                data: { agen }
            }).done(function (msg) {
                $(".lproductbaru").html(msg)
            });
        }
    })
})