<!--#include file="../../init.asp"-->
<% 
  ' if session("PR5A") = false then
  '   Response.Redirect("index.asp")
  ' end if
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.DLK_T_ReturnMaterialH.*, dbo.DLK_M_WebLogin.UserName, dbo.GLB_M_Agen.AgenName FROM DLK_T_ReturnMaterialH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ReturnMaterialH.RM_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ReturnMaterialH.RM_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_ReturnMaterialH.RM_AktifYN = 'Y') AND (dbo.DLK_T_ReturnMaterialH.RM_ID = '"&id&"')"

  set data = data_cmd.execute

  ' detail
  data_cmd.commandText = "SELECT dbo.DLK_T_ReturnMaterialD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_M_WebLogin RIGHT OUTER JOIN dbo.DLK_T_ReturnMaterialD INNER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_ReturnMaterialD.RM_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_WebLogin.UserID = dbo.DLK_T_ReturnMaterialD.RM_UpdateID LEFT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_T_ReturnMaterialD.RM_Item = dbo.DLK_M_Barang.brg_ID WHERE LEFT(DLK_T_ReturnMaterialD.RM_ID,13) = '"& data("RM_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama"
  ' response.write data_cmd.commandTExt & "<br>"
  set ddata = data_cmd.execute

  ' penerimaan barang produksi
  data_cmd.commandTExt = "SELECT (ISNULL(SUM(dbo.DLK_T_RCProdD.RCD_QtySatuan), 0) - ISNULL((SELECT SUM(dbo.DLK_T_ReturnMaterialD.RM_QtySatuan) AS qtyrm FROM dbo.DLK_T_ReturnMaterialH RIGHT OUTER JOIN dbo.DLK_T_ReturnMaterialD ON dbo.DLK_T_ReturnMaterialH.RM_ID = LEFT(dbo.DLK_T_ReturnMaterialD.RM_ID, 13) WHERE DLK_T_ReturnMaterialD.RM_Item =dbo.DLK_T_RCProdD.RCD_Item AND DLK_T_ReturnMaterialH.RM_PDHID = '"& data("RM_PDHID") &"' AND DLK_T_ReturnMaterialH.RM_AktifYN = 'Y' GROUP BY dbo.DLK_T_ReturnMaterialD.RM_item),0) )  AS qty, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_T_RCProdD.RCD_Item FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_RCProdD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_RCProdD.RCD_Item LEFT OUTER JOIN dbo.DLK_T_RCProdH ON LEFT(dbo.DLK_T_RCProdD.RCD_ID, 10) = dbo.DLK_T_RCProdH.RC_ID WHERE (LEFT(dbo.DLK_T_RCProdH.RC_PDDID, 13) = '"& data("RM_PDHID") &"') AND DLK_T_RCProdH.RC_AktifYN = 'Y' GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_RCProdH.RC_AktifYN, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_T_RCProdD.RCD_Item HAVING (ISNULL(SUM(dbo.DLK_T_RCProdD.RCD_QtySatuan), 0) - ISNULL((SELECT SUM(dbo.DLK_T_ReturnMaterialD.RM_QtySatuan) AS qtyrm FROM dbo.DLK_T_ReturnMaterialH RIGHT OUTER JOIN dbo.DLK_T_ReturnMaterialD ON dbo.DLK_T_ReturnMaterialH.RM_ID = LEFT(dbo.DLK_T_ReturnMaterialD.RM_ID, 13) WHERE DLK_T_ReturnMaterialD.RM_Item =dbo.DLK_T_RCProdD.RCD_Item AND DLK_T_ReturnMaterialH.RM_PDHID = '"& data("RM_PDHID") &"' AND DLK_T_ReturnMaterialH.RM_AktifYN = 'Y' GROUP BY dbo.DLK_T_ReturnMaterialD.RM_item),0) ) > 0 ORDER BY BRG_NAma"
  ' response.write data_cmd.commandText & "<br>"
  set getbarang = data_cmd.execute   


  call header("DETAIL RETURN MATERIAL")

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL RETURN MATERIAL PRODUKSI</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= left(data("RM_ID") ,2)%>-<%= mid(data("RM_ID") ,3,3)%>/<%= mid(data("RM_ID") ,6,4) %>/<%= right(data("RM_ID"),4) %></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="cabang" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= data("AgenName") %>"  readonly>
    </div>
    <div class="col-sm-2">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(data("RM_Date")) %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="agen" class="col-form-label">No.Produksi</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= left(data("RM_PDHID"),2) %>-<%= mid(data("RM_PDHID"),3,3) %>/<%= mid(data("RM_PDHID"),6,4) %>/<%= right(data("RM_PDHID"),4)  %>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="updateid" class="col-form-label">UpdateID</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= data("username") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="Terima" class="col-form-label">Serah Terima</label>
    </div>
    <div class="col-sm-4 mb-3">
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="Y" <% if data("RM_TerimaYN") = "Y" then%>checked <% end if %>disabled>
        <label class="form-check-label" for="Y" >Done</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="N" <% if data("RM_TerimaYN") = "N" then%>checked <% end if %>disabled
        > 
        <label class="form-check-label" for="N" >Waiting</label>
      </div>
    </div>
    <div class="col-sm-2">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" value="<%= data("RM_Keterangan") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 d-flex justify-content-between">
      <%' if session("MK1D") = true then %>
        <button type="button" class="btn btn-secondary" onclick="window.open('export-XlsRM.asp?id=<%=id%>','_self')">Export</button>
      <%' end if %>
      <button type="button" class="btn btn-danger" onclick="window.location.href='index.asp'">Kembali</button>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 mt-3">
      <table class="table" >
        <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Kode</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">UpdateID</th>
          </tr> 
        </thead>
        <tbody>
        <% 
        no = 0
        do while not ddata.eof 
        no = no + 1
        %>
          <tr>  
            <th scope="row"><%= no %></th>
            <th><%= ddata("KategoriNama") %>-<%= ddata("jenisNama") %></th>
            <td>
              <%= ddata("Brg_Nama") %>
            </td>
            <td><%= ddata("RM_qtysatuan") %></td>
            <td><%= ddata("sat_nama") %></td>
            <td>
              <%= replace(formatCurrency(ddata("RM_Harga")),"$","") %>
            </td>
             <td><%= ddata("username") %></td>
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