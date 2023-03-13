<!--#include file="../../init.asp"-->
<% 
  if session("PP3D") = false then
    Response.Redirect("index.asp")
  end if
  id = trim(Request.QueryString("id"))

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=Return Material "& id &".xls"

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.DLK_T_ReturnMaterialH.*, dbo.DLK_M_WebLogin.UserName, dbo.GLB_M_Agen.AgenName FROM DLK_T_ReturnMaterialH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ReturnMaterialH.RM_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ReturnMaterialH.RM_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_ReturnMaterialH.RM_AktifYN = 'Y') AND (dbo.DLK_T_ReturnMaterialH.RM_ID = '"&id&"')"

  set data = data_cmd.execute

  ' detail
  data_cmd.commandText = "SELECT dbo.DLK_T_ReturnMaterialD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_SatuanBarang.Sat_Nama, DLK_M_SatuanPanjang.SP_Nama FROM dbo.DLK_M_WebLogin RIGHT OUTER JOIN dbo.DLK_T_ReturnMaterialD INNER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_ReturnMaterialD.RM_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_WebLogin.UserID = dbo.DLK_T_ReturnMaterialD.RM_UpdateID LEFT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_T_ReturnMaterialD.RM_Item = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN DLK_M_SatuanPanjang ON DLK_T_ReturnMaterialD.RM_SPID = SP_ID WHERE LEFT(DLK_T_ReturnMaterialD.RM_ID,13) = '"& data("RM_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama"
  ' response.write data_cmd.commandTExt & "<br>"
  set ddata = data_cmd.execute

  call header("DETAIL RETURN MATERIAL")

%>
<table width="100%">
  <tr>
    <td colspan="9" align="center">DETAIL RETURN MATERIAL PRODUKSI</td>
  </tr>
  <tr>
    <td colspan="9" align="center"><%= left(data("RM_ID") ,2)%>-<%= mid(data("RM_ID") ,3,3)%>/<%= mid(data("RM_ID") ,6,4) %>/<%= right(data("RM_ID"),4) %></td>
  </tr>

  <tr>
    <td colspan="2">Cabang / Agen</td>
    <td colspan="2">: <%= data("AgenName") %></td>
    <td colspan="2">Tanggal</td>
    <td colspan="3">: <%= Cdate(data("RM_Date")) %></td>
  </tr>
  <tr>
    <td colspan="2">No.Produksi</td>
    <td colspan="2">: <%= left(data("RM_PDHID"),2) %>-<%= mid(data("RM_PDHID"),3,3) %>/<%= mid(data("RM_PDHID"),6,4) %>/<%= right(data("RM_PDHID"),4)  %></td>
    <td colspan="2">UpdateID</td>
    <td colspan="3">: <%= data("username") %></td>
  </tr>
  <tr>
    <td colspan="2">Serah Terima</td>
    <td colspan="2">
      : <% if data("RM_TerimaYN") = "Y" then%>Done <%  else %>Waiting <% end if %>
    </td>
    <td colspan="2">Keterangan</td>
    <td colspan="3">: <%= data("RM_Keterangan") %></td>
  </tr>

  <tr>
    <td colspan="9" align="center">&nbsp</td>
  </tr>
  <tr>
    <th scope="col" style="background-color: #0000a0;color:#fff;">No</th>
    <th scope="col" style="background-color: #0000a0;color:#fff;">Kode</th>
    <th scope="col" style="background-color: #0000a0;color:#fff;">Item</th>
    <th scope="col" style="background-color: #0000a0;color:#fff;">Dimension</th>
    <th scope="col" style="background-color: #0000a0;color:#fff;">Quantity</th>
    <th scope="col" style="background-color: #0000a0;color:#fff;">Satuan</th>
    <th scope="col" style="background-color: #0000a0;color:#fff;">Total Qty</th>
    <th scope="col" style="background-color: #0000a0;color:#fff;">Harga</th>
    <th scope="col" style="background-color: #0000a0;color:#fff;">UpdateID</th>
  </tr> 
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
        <td><%= ddata("RM_Dimension") %></td>
        <td><%= ddata("RM_qtysatuan") %></td>
        <td><%= ddata("sat_nama") %></td>
        <td class="text-end"><%= ddata("RM_TotalQtyMM") &" "& ddata("SP_Nama") %></td>
        <td>
          <%= replace(formatCurrency(ddata("RM_Harga")),"$","") %>
        </td>
        <th><%= ddata("username") %></th>
      </tr>
    <% 
    ddata.movenext
    loop
  %>
</table>
