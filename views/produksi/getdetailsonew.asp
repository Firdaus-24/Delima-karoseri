<!--#include file="../../init.asp"-->
<%
  dim id, data
  id = trim(Request.QueryString("id"))

  set data_cmd = Server.CreateObject("ADODB.COmmand")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.MKT_T_OrJulH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.MKT_T_OrJulH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_OrJulH.OJH_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_OrJulH.OJH_CustID = dbo.DLK_M_Customer.custId WHERE (MKT_T_OrJulH.OJH_AktifYN = 'Y') AND (MKT_T_OrJulH.OJH_ID = '"& id &"')"
  set data = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.MKT_T_OrJulD.OJD_OJHID, dbo.MKT_T_OrJulD.OJD_Item, dbo.MKT_T_OrJulD.OJD_Qtysatuan, dbo.MKT_T_OrJulD.OJD_JenisSat, dbo.MKT_T_OrJulD.OJD_Harga, dbo.MKT_T_OrJulD.OJD_Diskon, dbo.MKT_T_OrJulD.OJD_Keterangan, dbo.MKT_T_OrJulD.OJD_Updatetime, dbo.MKT_T_OrJulD.OJD_UpdateID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_WebLogin.username FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.MKT_T_OrJulD ON dbo.DLK_M_Barang.Brg_Id = dbo.MKT_T_OrJulD.OJD_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_OrJulD.OJD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_WebLogin ON MKT_T_OrjulD.OJD_Updateid = DLK_M_webLogin.userid WHERE LEFT(dbo.MKT_T_OrJulD.OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY dbo.MKT_T_OrjulD.OJD_OJHID" 
  set ddata = data_cmd.execute
  if not data.eof then
%>
    <div class="row">
      <div class="col-lg-12 mt-3 mb-3 text-center">
        <h3>DETAIL SALES ORDER</h3>
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
      <div class="col-lg-12">
        <table class="table table-hover table-bordered">
          <thead class="bg-secondary text-light">
            <tr>
              <th scope="col">No</th>
              <th scope="col">Kategori</th>
              <th scope="col">Jenis</th>
              <th scope="col">Model</th>
              <th scope="col">Keterangan</th>
              <th scope="col">Quantity</th>
              <th scope="col">Satuan</th>
              <th scope="col">Harga</th>
              <th scope="col">Diskon</th>
              <th scope="col">Sub Total</th>
            </tr>
          </thead>
          <tbody>
            <% 
            no = 0
            total = 0
            subtotal = 0
            dis = 0
            do while not ddata.eof 
            no = no + 1

            if ddata("OJD_Diskon") <> 0 then 
              dis = ((ddata("OJD_Diskon")/100) * ddata("OJD_Harga")) * ddata("OJD_Qtysatuan") 
            end if
            subtotal = (ddata("OJD_Harga") * ddata("OJD_Qtysatuan")) - dis
            total = total + subtotal
            %>
              <tr>
                <th>
                  <%= no  %>
                </th>
                <td>
                  <%= ddata("KategoriNama") %>
                </td>
                <td>
                  <%= ddata("jenisNama") %>
                </td>
                <td>
                  <%= ddata("Brg_Nama") %>
                </td>
                <td>
                  <%= ddata("OJD_Keterangan")%>
                </td>
                <td>
                  <%= ddata("OJD_Qtysatuan")%>
                </td>
                <td>
                  <%= ddata("sat_Nama")%>
                </td>
                <td class="text-end">
                  <%= replace(formatCurrency(ddata("OJD_Harga")),"$","")%>
                </td>
                <td>
                  <%= ddata("OJD_Diskon")%>
                </td>
                <td class="text-end">
                  <%= replace(formatCurrency(subtotal),"$","")%>
                </td>
              </tr>
            <% 
            Response.flush
            ddata.movenext
            loop

            ' ppn
            ppn = (data("OJH_ppn") / 100) * total
            'diskon all
            disall = (data("OJH_DiskonAll") / 100) * total
            ' grandtotal
            total = total + ppn - disall
            %>
            <tr>
              <td colspan="8">PPN</td>
              <td><%= data("OJH_ppn") %></td>
              <td class="text-end"><%= replace(formatCurrency(ppn),"$","")%></td>
            </tr>
            <tr>
              <td colspan="8">Diskon All</td>
              <td><%= data("OJH_DiskonAll") %></td>
              <td class="text-end"><%= replace(formatCurrency(disall),"$","")%></td>
            </tr>
            <tr>
              <td colspan="9">Grand Total</td>
              <td class="text-end"><%= replace(formatCurrency(total),"$","")%></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div> 
<%else%>
  <div class='row'>
    <div class='col-lg-12 text-center'>
      <h3>
        DATA TIDAK TERDAFTAR
      </h3>
    </div>
  </div>
<%end if%>