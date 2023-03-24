<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_serahterimaunit.asp"-->
<%  
  if session("MQ2A") = false then
    Response.Redirect("index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT OJH_ID, CustNama FROM DLK_T_OrjulH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_OrjulH.OJH_Custid = DLK_M_Customer.custID WHERE OJH_AktifYN = 'Y' AND NOT EXISTS(SELECT TFK_OJHID FROM DLK_T_UnitCustomerH WHERE TFK_OJHID = OJH_ID AND TFK_AktifYN = 'Y') ORDER BY OJH_ID ASC"

  set data = data_cmd.execute

  call header("Tambah Unit")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 mt-3 text-center">
      <h3>FROM TAMBAH KEDATANGAN UNIT</h3>
    </div>
  </div>

  <form action="tfk_add.asp" method="post" onsubmit="validasiForm(this,event,'SERAH TERIMA UNIT CUSTOMER','warning')">
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="salesorder" class="col-form-label">Sales Order</label>
      </div>
      <div class="col-lg-4 mb-3">
        <select class="form-select" aria-label="Default select example" id="salesorder" name="salesorder" autofocusrequired>
            <option value="">Pilih</option>
            <% do while not data.eof %>
            <option value="<%= data("OJH_ID") %>">
              <%= left(data("OJH_ID"),2) &"-"& mid(data("OJH_ID"),3,3) &"/"& mid(data("OJH_ID"),6,4) &"/"& right(data("OJH_ID"),4)  %>
            </option>
            <% 
            data.movenext
            loop
            %>
        </select>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="customer" class="col-form-label">Customer</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="hidden" id="custid" name="custid" class="form-control" readonly>
        <input type="text" id="customer" name="customer" class="form-control" readonly>
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="penerima" class="col-form-label">Penerima</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="penerima" name="penerima" class="form-control" maxlength="50" required>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="tgl" name="tgl" value="<%= date %>" class="form-control" onfocus="(this.type='date')" required>
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="penyerah" class="col-form-label">Penyerah</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="penyerah" name="penyerah" class="form-control" maxlength="50" required>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
      </div>
    </div>
    <div class="row">
      <div class="col-lg-12 mb-3 mt-3 text-center">
        <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </div>
  </form>
</div>  

<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahSerahterima()
  end if

  call footer() 
%>
<script>
  $("#salesorder").change(function(){
    let ojhid
    $.post('getcustomer.asp', {ojhid:$("#salesorder").val()}, function(data){
      $("#custid").val(String(data[0].ID));
      $("#customer").val(String(data[0].NAMA));
    })
  })
</script>