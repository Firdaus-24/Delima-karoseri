<!--#include file="../../init.asp"-->
<% 
  ' if session("PR2A") = false then
  ' Response.Redirect("index.asp") 
  ' end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.DLK_T_OrJulH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_OrJulH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_OrJulH.OJH_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_OrJulH.OJH_CustID = dbo.DLK_M_Customer.custId WHERE (DLK_T_OrJulH.OJH_AktifYN = 'Y') AND (DLK_T_OrJulH.OJH_ID = '"& id &"')"

  set data = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.DLK_T_OrJulD.OJD_OJHID, dbo.DLK_T_OrJulD.OJD_Item, dbo.DLK_T_OrJulD.OJD_Qtysatuan, dbo.DLK_T_OrJulD.OJD_JenisSat, dbo.DLK_T_OrJulD.OJD_Harga, dbo.DLK_T_OrJulD.OJD_Diskon, dbo.DLK_T_OrJulD.OJD_Keterangan, dbo.DLK_T_OrJulD.OJD_Updatetime, dbo.DLK_T_OrJulD.OJD_UpdateID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_WebLogin.username FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_OrJulD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_OrJulD.OJD_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_OrJulD.OJD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_OrjulD.OJD_Updateid = DLK_M_webLogin.userid WHERE LEFT(dbo.DLK_T_OrJulD.OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY dbo.DLK_T_OrjulD.OJD_OJHID" ' response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute


call header("Detail SalesOrder") %>
  <!--#include file="../../navbar.asp"-->
  <div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
          <h3>DETAIL SALES ORDER</h3>
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
        <input type="text" id="tgl" name="tgl" value="<%= cdate(data("OJH_Date")) %>" class="form-control" readonly>
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
        <input type="text" id="tgljt" name="tgljt" class="form-control" <% if Cdate(data("OJH_JTDate")) <> Cdate("1/1/1900") then%> value="<%= cdate(data("OJH_JTDate")) %>" <% end if %> readonly>
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="diskon" class="col-form-label">Diskon All</label>
      </div>
      <div class="col-lg-4 mb-3">
        <div class="input-group ">
          <input type="number" id="diskon" name="diskon" value="<%= data("OJH_DiskonAll") %>"  class="form-control" readonly>
          <span class="input-group-text" >%</span>
        </div>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="ppn" class="col-form-label">PPn</label>
      </div>
      <div class="col-lg-4 mb-3">
        <div class="input-group ">
          <input type="number" id="diskon" name="diskon" value="<%= data("OJH_ppn") %>"  class="form-control" readonly>
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
          <input type="number" id="diskon" name="diskon" value="<%= data("OJH_timeWork") %>"  class="form-control" readonly>
          <span class="input-group-text" >/ Hari</span>
        </div>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off"  value="<%= data("OJH_Keterangan") %>" readonly>
      </div>
    </div>
    <div class="row">
      <div class="col-lg-12 mb-3 text-center d-flex justify-content-between">
        <% if session("MK1D") = true then %>
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
                <th scope="col">Kode</th>
                <th scope="col">Item</th>
                <th scope="col">Quantity</th>
                <th scope="col">Satuan</th>
                <th scope="col">Harga</th>
                <th scope="col">Diskon</th>
                <th scope="col">UpdateTime</th>
                <th scope="col">UpdateID</th>
            </tr>
          </thead>
          <tbody>
            <% 
            do while not ddata.eof 
            %>
              <tr>
                <th>
                  <%= left(ddata("OJD_OJHID"),2) %>-<%= mid(ddata("OJD_OJHID"),3,3) %>/<%= mid(ddata("OJD_OJHID"),6,4) %>/<%= mid(ddata("OJD_OJHID"),10,4) %>/<%= right(ddata("OJD_OJHID"),3)  %>
                </th>
                <td>
                  <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                </td>
                <td>
                  <%= ddata("Brg_Nama") %>
                </td>
                <td>
                  <%= ddata("OJD_Qtysatuan")%>
                </td>
                <td>
                  <%= ddata("sat_Nama")%>
                </td>
                <td>
                  <%= replace(formatCurrency(ddata("OJD_Harga")),"$","")%>
                </td>
                <td>
                  <%= ddata("OJD_Diskon")%>
                </td>
                <td>
                  <%= ddata("OJD_updatetime")%>
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