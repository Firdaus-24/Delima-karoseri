<!--#include file="../../init.asp"-->
<% 
   if session("ENG1D") = false then
      Response.Redirect("index.asp")
   end if   

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_T_ProduksiD.PDD_BMID, dbo.DLK_T_ProduksiH.PDH_ID, dbo.DLK_T_ProduksiH.PDH_StartDate, dbo.DLK_T_ProduksiH.PDH_EndDate FROM dbo.DLK_T_ProduksiH LEFT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_T_ProduksiH.PDH_ID = LEFT(dbo.DLK_T_ProduksiD.PDD_ID, 13) GROUP BY dbo.DLK_T_ProduksiD.PDD_BMID, dbo.DLK_T_ProduksiH.PDH_ID,  dbo.DLK_T_ProduksiH.PDH_StartDate, dbo.DLK_T_ProduksiH.PDH_EndDate, dbo.DLK_T_ProduksiH.PDH_Approve1, dbo.DLK_T_ProduksiH.PDH_Approve2, dbo.DLK_T_ProduksiH.PDH_AktifYN HAVING (dbo.DLK_T_ProduksiH.PDH_AktifYN = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_ID = '"& id &"') ORDER BY DLK_T_ProduksiD.PDD_BMID ASC"

   set data = data_cmd.execute

   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=Produksi "& left(data("PDH_ID"),2) &"-"& mid(data("PDH_ID"),3,3) &"/"& mid(data("PDH_ID"),6,4) &"/"& right(data("PDH_ID"),4) &".xls"


   call header("Print Produksi")
%>
<table width="100%">
   <tr>
      <th align="center" colspan="4">
         DETAIL MATERIAL B.O.M PRODUKSI <%= left(data("PDH_ID"),2) %>-<%= mid(data("PDH_ID"),3,3) %>/<%= mid(data("PDH_ID"),6,4) %>/<%= right(data("PDH_ID"),4)  %>
      </th>
   </tr>
   <tr>
      <th align="center" colspan="4">
         Priode <%= Cdate(data("PDH_StartDate")) &" - "& Cdate(data("PDH_EndDate")) %>
      </th>
   </tr>
   <tr>
      <td colspan="4">
         &nbsp
      </td>
   </tr>
</table>
<% do while not data.eof 
' get header BOM
data_cmd.commandTExt = "SELECT COUNT(dbo.DLK_T_ProduksiD.PDD_ID) AS capacty, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_M_Barang INNER JOIN dbo.DLK_M_BOMH ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_BOMH.BMBrgID RIGHT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID WHERE DLK_T_ProduksiD.PDD_BMID = '"& data("PDD_BMID") &"' GROUP BY dbo.DLK_M_Barang.Brg_Nama"

set hbom = data_cmd.execute

' get detail bom
data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_BOMD.BMDQtty, dbo.DLK_M_BOMD.BMDBMID, dbo.DLK_M_BOMH.BMID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_M_SatuanBarang INNER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_M_BOMD.BMDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_M_BOMD.BMDItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_BOMH ON LEFT(dbo.DLK_M_BOMD.BMDBMID, 12) = dbo.DLK_M_BOMH.BMID WHERE (dbo.DLK_M_BOMH.BMID = '"& data("PDD_BMID") &"') AND (dbo.DLK_M_BOMH.BMAktifYN = 'Y') AND (dbo.DLK_M_BOMH.BMApproveYN = 'Y')"

set dbom = data_cmd.execute

' get nomor drawing
data_cmd.commandTExt = "SELECT ISNULL(dbo.DLK_M_Sasis.SasisType, '') AS type, ISNULL(dbo.DLK_M_Brand.BrandName, '') AS brand, ISNULL(dbo.DLK_M_Sasis.SasisDrawing, '') AS drawing FROM dbo.DLK_M_Brand INNER JOIN dbo.DLK_M_Sasis ON dbo.DLK_M_Brand.BrandID = dbo.DLK_M_Sasis.SasisBrandID RIGHT OUTER JOIN dbo.DLK_M_BOMH ON dbo.DLK_M_Sasis.SasisID = dbo.DLK_M_BOMH.BMSasisID WHERE (dbo.DLK_M_BOMH.BMAktifYN = 'Y') AND (dbo.DLK_M_BOMH.BMID = '"& data("PDD_BMID") &"') "
set getsasis = data_cmd.execute

%>
<table width=""100%>
   <tr>  
      <td >No B.O.M</td>
      <td colspan="3">
         : <%= left(data("PDD_BMID"),2) %>-<%= mid(data("PDD_BMID"),3,3) %>/<%= mid(data("PDD_BMID"),6,4) %>/<%= right(data("PDD_BMID"),3) %>
      </td>
   </tr>
   <tr>
      <td >Item</td>
      <td colspan="3">
         : <%= hbom("Brg_Nama") %>
      </td>
   </tr>
   <tr>
      <td >Capaity</td>
      <td colspan="3">
         : <%= hbom("capacty") %>
      </td>
   </tr>
   <tr>
      <td >Type</td>
      <td colspan="3">
         : <%= getsasis("type") %>
      </td>
   </tr>
   <tr>
      <td >Brand</td>
      <td colspan="3">
         : <%= getsasis("brand") %>
      </td>
   </tr>
   <tr>
      <td >No.Drawing</td>
      <td colspan="3">
         : <%= LEft(getsasis("drawing"),5) &"-"& mid(getsasis("drawing"),6,4) &"-"& right(getsasis("drawing"),3) %>
      </td>
   </tr>
   <tr>
      <td style="background-color: #0000a0;color:#fff;">
         Kode Barang
      </td>
      <td style="background-color: #0000a0;color:#fff;">
         Nama Barang
      </td>
      <td style="background-color: #0000a0;color:#fff;">
         Quantity
      </td>
      <td style="background-color: #0000a0;color:#fff;">
         Satuan
      </td>
   </tr>
   <% do while not dbom.eof %>
   <tr>
      <td>
         <%= dbom("KategoriNama") &"-"& dbom("jenisNama") %> 
      </td>
      <td>
         <%= dbom("Brg_Nama") %> 
      </td>
      <td>
         <%= dbom("BMDQtty") %> 
      </td>
      <td>
         <%= dbom("Sat_nama") %> 
      </td>
   </tr>
   <% 
   response.flush
   dbom.movenext
   loop
   %>
   <tr>
      <td>
         &nbsp
      </td>
   </tr>
</table>
<% 
response.flush
data.movenext
loop
%>
<% 
   call footer()
%>