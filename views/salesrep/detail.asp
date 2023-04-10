<!--#include file="../../init.asp"-->
<% 
  ' if session("PR2A") = false then
  ' Response.Redirect("index.asp") 
  ' end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.MKT_T_OrJulRepairH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.MKT_T_OrJulRepairH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_OrJulRepairH.ORH_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_OrJulRepairH.ORH_CustID = dbo.DLK_M_Customer.custId WHERE (MKT_T_OrJulRepairH.ORH_AktifYN = 'Y') AND (MKT_T_OrJulRepairH.ORH_ID = '"& id &"')"

  set data = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Brand.BrandName, dbo.MKT_T_OrjulRepairD.ORD_ID, dbo.MKT_T_OrjulRepairD.ORD_Qtysatuan, dbo.MKT_T_OrjulRepairD.ORD_Harga, dbo.MKT_T_OrjulRepairD.ORD_Diskon, dbo.MKT_T_OrjulRepairD.ORD_Keterangan, dbo.MKT_T_OrjulRepairD.ORD_UpdateId, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_WebLogin.UserName FROM dbo.MKT_T_OrjulRepairD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.MKT_T_OrjulRepairD.ORD_UpdateId = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_OrjulRepairD.ORD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.MKT_T_OrjulRepairD.ORD_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.MKT_T_OrjulRepairD.ORD_ClassID = dbo.DLK_M_Class.ClassID WHERE LEFT(dbo.MKT_T_OrJulRepairD.ORD_ID,13) = '"& data("ORH_ID") &"' ORDER BY dbo.MKT_T_OrjulRepairD.ORD_ID" ' response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute

call header("Detail SalesOrder") %>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL SALES ORDER REPAIR</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3>
        <%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)  %>
      </h3>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="agen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="agen" name="agen" value="<%= data("agenName") %>" class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" value="<%= cdate(data("ORH_Date")) %>" class="form-control" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="customer" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="agen" name="agen" value="<%= data("custnama") %>" class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgljt" name="tgljt" class="form-control" <% if Cdate(data("ORH_JTDate")) <> Cdate("1/1/1900") then%> value="<%= cdate(data("ORH_JTDate")) %>" <% end if %> readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="diskon" class="col-form-label">Diskon All</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" id="diskon" name="diskon" value="<%= data("ORH_DiskonAll") %>"  class="form-control" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="ppn" class="col-form-label">PPn</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" id="diskon" name="diskon" value="<%= data("ORH_ppn") %>"  class="form-control" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="timeWork" class="col-form-label">Lama Pengerjaan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" id="diskon" name="diskon" value="<%= data("ORH_timeWork") %>"  class="form-control" readonly>
        <span class="input-group-text" >/ Hari</span>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off"  value="<%= data("ORH_Keterangan") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center d-flex justify-content-between">
      <% if session("MK2D") = true then %>
      <button type="button" class="btn btn-secondary" onclick="window.open('export-XlsSO.asp?id=<%=id%>')">Export</button>
      <% end if %>
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">ID</th>
            <th scope="col">Class</th>
            <th scope="col">Brand</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">Diskon</th>
            <th scope="col">UpdateID</th>
          </tr>
        </thead>
        <tbody>
        <% 
        do while not ddata.eof 
        %>
          <tr>
            <th>
              <%= left(ddata("ORD_ID"),2) %>-<%= mid(ddata("ORD_ID"),3,3) %>/<%= mid(ddata("ORD_ID"),6,4) %>/<%= mid(ddata("ORD_ID"),10,4) %>/<%= right(ddata("ORD_ID"),3)  %>
            </th>
            <td>
              <%= ddata("className") %>
            </td>
            <td>
              <%= ddata("brandName") %>
            </td>
            <td>
              <%= ddata("ORD_Qtysatuan")%>
            </td>
            <td>
              <%= ddata("sat_Nama")%>
            </td>
            <td>
              <%= replace(formatCurrency(ddata("ORD_Harga")),"$","")%>
            </td>
            <td>
              <%= ddata("ORD_Diskon")%>
            </td>
            <td>
              <%= ddata("username")%>
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
<%call footer() %>