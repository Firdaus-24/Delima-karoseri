<!--#include file="../../init.asp"-->
<% 

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.MKT_T_InvRepairH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama FROM dbo.MKT_T_InvRepairH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_InvRepairH.INV_CustID = dbo.DLK_M_Customer.custId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_InvRepairH.INV_Agenid = dbo.GLB_M_Agen.AgenID WHERE INV_AktifYN = 'Y' AND INV_ID = '"& id &"'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  ' detail invoice
  data_cmd.commandText = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Brand.BrandName, dbo.MKT_T_InvRepairD.IRD_INVID, dbo.MKT_T_InvRepairD.IRD_Qtysatuan,dbo.MKT_T_InvRepairD.IRD_Harga, dbo.MKT_T_InvRepairD.IRD_Diskon, dbo.MKT_T_InvRepairD.IRD_Keterangan, dbo.MKT_T_InvRepairD.IRD_UpdateId, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_WebLogin.UserName FROM dbo.MKT_T_InvRepairD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.MKT_T_InvRepairD.IRD_UpdateId = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_InvRepairD.IRD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.MKT_T_InvRepairD.IRD_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.MKT_T_InvRepairD.IRD_ClassID = dbo.DLK_M_Class.ClassID WHERE LEFT(dbo.MKT_T_InvRepairD.IRD_INVID,13) = '"& data("INV_ID") &"' ORDER BY dbo.MKT_T_InvRepairD.IRD_INVID"

  set ddata = data_cmd.execute

  call header("Detail Invoice Repair")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL INVOICE REPAIR</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= LEFT(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"&  right(id,4) %></h3>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="agen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="" name="" value="<%= data("AgenName") %>"  class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="ophid" class="col-form-label">No P.O</label>
    </div>
    <div class="col-lg-4 mb-3 inv-repairmkt-lama">
      <input type="text" id="" name="" value="<%= left(data("INV_ORHID"),2) %>-<%= mid(data("INV_ORHID"),3,3) %>/<%= mid(data("INV_ORHID"),6,4) %>/<%= right(data("INV_ORHID"),4) %>"  class="form-control" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="" name="" value="<%= Cdate(data("INV_Date")) %>"  class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="" class="col-form-label">Tanggal Jatuh Tempo</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="" name="" <% if  Cdate(data("INV_JTDate")) <> Cdate("1900-01-01") then %> value="<%= Cdate(data("INV_JTDate")) %>" <% end if %> class="form-control" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="customer" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="text" class="form-control" id="" name="custname" value="<%= data("custNama") %>" readonly>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="uangmuka" class="col-form-label">Uang Muka Terbayar</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="text" class="form-control" id="uangmuka-repair" name="uangmuka" value="<%= replace(formatcurrency(data("INV_Uangmuka")),"$","Rp. ") %>" readonly>
      </div>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="diskon" class="col-form-label">Diskon All</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" class="form-control" id="diskon-repair" name="diskon" value="<%= data("Inv_DiskonAll") %>" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="ppn" class="col-form-label">PPn</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" class="form-control" id="" name="ppn" value="<%= data("Inv_PPN") %>" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" class="form-control" id="" name="ppn" value="<%= data("INV_Keterangan") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="timework" class="col-form-label">Lama Pengerjaan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="text" class="form-control" id="" name="ppn" value="<%= data("INV_timework") %>" readonly>
        <span class="input-group-text" >Hari</span>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="d-flex mb-3">
      <div class="me-auto p-2">
        <% if session("MK4D") = true then %>
        <button type="button" class="btn btn-outline-primary" onclick="window.open('export-Xlsinvoicerepair.asp?id=<%=id%>', '_self')">
          <i class="bi bi-filetype-exe"></i> Excel
        </button>
        <button type="button" class="btn btn-outline-primary" onclick="window.open('print-invoice.asp?id=<%=id%>', '_self')">
          <i class="bi bi-printer"></i> Print
        </button>
        <% end if %>
      </div>
      <div class="p-2">
        <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">Class</th>
            <th scope="col">Brand</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">Diskon</th>
            <th scope="col">UpdateID</th>
            <th scope="col">Keterangan</th>
          </tr>
        </thead>
        <tbody>
          <% 
          do while not ddata.eof 
          %>
            <tr>
              <td>
                <%= ddata("className") %>
              </td>
              <td>
                <%= ddata("brandName") %>
              </td>
              <td>
                <%= ddata("IRD_Qtysatuan")%>
              </td>
              <td>
                <%= ddata("sat_Nama")%>
              </td>
              <td>
                <%= replace(formatCurrency(ddata("IRD_Harga")),"$","")%>
              </td>
              <td>
                <%= ddata("IRD_Diskon")%>
              </td>
              <td>
                <%= ddata("username")%>
              </td>
              <td>
                <%= ddata("IRD_KEterangan")%>
              </td>
            </tr>
          <% 
          ddata.movenext
          loop
          %>
        </tbody>
      </table>
    </div>    
  </div>   
</div>  
<% 
  call footer()
%>