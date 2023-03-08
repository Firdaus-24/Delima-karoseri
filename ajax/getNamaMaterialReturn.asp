<!--#include file="../init.asp"-->
<% 
  nproduksi = trim(Request.Form("pdhidrm"))
  nama = Ucase(trim(Request.Form("namaReturnMaterial")))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT (ISNULL(SUM(dbo.DLK_T_RCProdD.RCD_QtySatuan), 0) - ISNULL((SELECT SUM(dbo.DLK_T_ReturnMaterialD.RM_QtySatuan) AS qtyrm FROM dbo.DLK_T_ReturnMaterialH RIGHT OUTER JOIN dbo.DLK_T_ReturnMaterialD ON dbo.DLK_T_ReturnMaterialH.RM_ID = LEFT(dbo.DLK_T_ReturnMaterialD.RM_ID, 13) WHERE DLK_T_ReturnMaterialD.RM_Item =dbo.DLK_T_RCProdD.RCD_Item AND DLK_T_ReturnMaterialH.RM_PDHID = '"& nproduksi &"' AND DLK_T_ReturnMaterialH.RM_AktifYN = 'Y' GROUP BY dbo.DLK_T_ReturnMaterialD.RM_item),0) )  AS qty, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_T_RCProdD.RCD_Item FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_RCProdD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_RCProdD.RCD_Item LEFT OUTER JOIN dbo.DLK_T_RCProdH ON LEFT(dbo.DLK_T_RCProdD.RCD_ID, 10) = dbo.DLK_T_RCProdH.RC_ID WHERE (LEFT(dbo.DLK_T_RCProdH.RC_PDDID, 13) = '"& nproduksi &"') AND DLK_T_RCProdH.RC_AktifYN = 'Y' AND UPPER(DLK_M_Barang.Brg_nama) LIKE '%"& nama &"%' GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_RCProdH.RC_AktifYN, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_T_RCProdD.RCD_Item HAVING (ISNULL(SUM(dbo.DLK_T_RCProdD.RCD_QtySatuan), 0) - ISNULL((SELECT SUM(dbo.DLK_T_ReturnMaterialD.RM_QtySatuan) AS qtyrm FROM dbo.DLK_T_ReturnMaterialH RIGHT OUTER JOIN dbo.DLK_T_ReturnMaterialD ON dbo.DLK_T_ReturnMaterialH.RM_ID = LEFT(dbo.DLK_T_ReturnMaterialD.RM_ID, 13) WHERE DLK_T_ReturnMaterialD.RM_Item =dbo.DLK_T_RCProdD.RCD_Item AND DLK_T_ReturnMaterialH.RM_PDHID = '"& nproduksi &"' AND DLK_T_ReturnMaterialH.RM_AktifYN = 'Y' GROUP BY dbo.DLK_T_ReturnMaterialD.RM_item),0) ) > 0 ORDER BY BRG_NAma"
  ' response.write data_cmd.commandText & "<br>"
  set getbarang = data_cmd.execute

%>

<% 
  angka = 0
  do while not getbarang.eof 
  angka = angka + 1
  %>
  <tr>
    <th>
      <%= angka %>
    </th>
    <th>
      <%= getbarang("KategoriNama") &"-"& getbarang("jenisNama") %>
    </th>
    <td>
      <%= getbarang("Brg_Nama") %>
    </td>
    <td>
      <%= getbarang("qty") %>
    </td>
    <td>
        <input class="form-check-input" type="radio" value="<%= getbarang("RCD_Item") %>" name="item" id="item" onchange="getHargaRC('<%= getbarang("RCD_Item") %>','<%= getbarang("qty") %>')" required>
    </td>
  </tr>
  <% 
  response.flush
  getbarang.movenext
  loop
%>