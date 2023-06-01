const getSerahTerimaUnitBySO = (e) => {
  $.post(`getsalesorder.asp`, { jenisUnit: e }, function (data) {
    $("#salesorder-serahterimaunit").html(data)
  })

}

const getCustomerSerahTerimaUnit = (e) => {
  $.post('getcustomer.asp', { ojhid: e }, function (data) {
    $("#custid").val(String(data[0].ID));
    $("#customer").val(String(data[0].NAMA));
  })
}
