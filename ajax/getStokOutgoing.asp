<!--#include file="../init.asp"-->
<% 
   cabang = trim(Request.Form("cabang"))
   nama = trim(Request.Form("nama"))

   set ajaxData_cmd =  Server.CreateObject ("ADODB.Command")
   ajaxData_cmd.ActiveConnection = mm_delima_string

   ajaxData_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_ID, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_TypeBarang.T_ID, dbo.DLK_M_TypeBarang.T_Nama, ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y' AND DB_Acc1 = 'Y' AND DB_Acc2 = 'Y'),0),0) as stok, ISNULL(dbo.DLK_T_MaterialReceiptD2.MR_Harga, 0) as harga, ISNULL((SELECT TOP 1 dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE DLK_T_MaterialReceiptD2.MR_Item = DLK_M_Barang.Brg_ID GROUP BY Sat_nama),'') as satuan FROM DLK_M_Barang LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID  LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_T_MaterialReceiptD2 ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_MaterialReceiptD2.MR_Item WHERE Brg_AktifYN = 'Y' AND LEFT(Brg_ID,3) = '"& cabang &"' AND (dbo.DLK_M_Barang.Brg_nama LIKE '%"& nama &"%') AND ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y' AND DB_Acc1 = 'Y' AND DB_Acc2 = 'Y'),0),0) > 0 GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_MinStok, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_TypeBarang.T_ID, dbo.DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_ID, dbo.DLK_T_MaterialReceiptD2.MR_Harga ORDER BY Brg_Nama ASC"
   ' response.write ajaxData_cmd.commandText & "<br>"
   set getAjaxstok = ajaxData_cmd.execute
%>
<%do while not getAjaxstok.eof %>
   <tr>
      <td><%= getAjaxstok("kategoriNama") &"-"& getAjaxstok("jenisNama") %></td>
      <td><%= getAjaxstok("Brg_Nama") %></td>
      <td><%= getAjaxstok("satuan") %></td>
      <td><%= getAjaxstok("stok") %></td>
      <td class="text-center">
         <div class="form-check form-check-inline">
               <input class="form-check-input" type="radio" name="ckbrgid" id="ckbrgid" value="<%=  getAjaxstok("Brg_ID") %>" onclick="getDataOutgoing('<%=getAjaxstok("harga")%>', '<%= getAjaxstok("stok") %>', '<%= getAjaxstok("brg_ID") %>')" required>
         </div>
      </td>
   </tr>
<% 
getAjaxstok.movenext
loop
%>