<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_ceil.asp"-->
<% 
   if session("ENG1D") = false then
      Response.Redirect("./")
   end if   

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' cek header
   data_cmd.commandTExt = "SELECT dbo.DLK_T_ProduksiH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama, dbo.MKT_T_OrJulH.OJH_TimeWork FROM dbo.DLK_M_Customer INNER JOIN dbo.MKT_T_OrJulH ON dbo.DLK_M_Customer.custId = dbo.MKT_T_OrJulH.OJH_CustID RIGHT OUTER JOIN dbo.DLK_T_ProduksiH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ProduksiH.PDH_AgenID = dbo.GLB_M_Agen.AgenID ON dbo.MKT_T_OrJulH.OJH_ID = dbo.DLK_T_ProduksiH.PDH_OJHID WHERE PDH_ID = '"& id &"' AND PDH_AktifYN = 'Y'"
   set datah = data_cmd.execute

   if datah.eof then
      Response.Redirect("./")
   end if

   data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, COUNT(dbo.DLK_T_ProduksiD.PDD_BMID) AS capacity, dbo.DLK_M_BOMH.BMID FROM dbo.DLK_M_BOMH LEFT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProduksiD.PDD_Item = dbo.DLK_M_Barang.Brg_Id WHERE (LEFT(dbo.DLK_T_ProduksiD.PDD_ID, 13) = '"& id &"') GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_BOMH.BMID ORDER BY dbo.DLK_M_Barang.Brg_Nama"

   set data = data_cmd.execute

   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=Produksi "& left(datah("PDH_ID"),2) &"-"& mid(datah("PDH_ID"),3,3) &"/"& mid(datah("PDH_ID"),6,4) &"/"& right(datah("PDH_ID"),4) &".xls"

%>
<table width="100%">
   <tr>
      <th style="text-align:center" colspan="6">
         DETAIL PRODUKSI <%= left(datah("PDH_ID"),2) %>-<%= mid(datah("PDH_ID"),3,3) %>/<%= mid(datah("PDH_ID"),6,4) %>/<%= right(datah("PDH_ID"),4)  %>
      </th>
   </tr>
   <tr>
      <th style="text-align:center" colspan="6">
         Priode : <%= Cdate(datah("PDH_StartDate")) &" - "& Cdate(datah("PDH_EndDate")) %>
      </th>
   </tr>
   <tr>
      <th style="text-align:center" colspan="6">
         Customer : <%= Ucase(datah("custnama")) %>
      </th>
   </tr>
   <tr>
      <td colspan="6">
         &nbsp
      </td>
   </tr>
</table>
<% do while not data.eof 

' get detail bom
data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_BOMD.BMDQtty, dbo.DLK_M_BOMD.BMDBMID, dbo.DLK_M_BOMH.BMID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_M_SatuanBarang INNER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_M_BOMD.BMDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_M_BOMD.BMDItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_BOMH ON LEFT(dbo.DLK_M_BOMD.BMDBMID, 12) = dbo.DLK_M_BOMH.BMID WHERE (dbo.DLK_M_BOMH.BMID = '"& data("BMID") &"') AND (dbo.DLK_M_BOMH.BMAktifYN = 'Y') AND (dbo.DLK_M_BOMH.BMApproveYN = 'Y')"

set dbom = data_cmd.execute

' get nomor drawing
data_cmd.commandTExt = "SELECT ISNULL(dbo.DLK_M_Sasis.SasisType, '') AS type, ISNULL(dbo.DLK_M_Brand.BrandName, '') AS brand, ISNULL(dbo.DLK_M_Sasis.SasisDrawing, '') AS drawing FROM dbo.DLK_M_Brand INNER JOIN dbo.DLK_M_Sasis ON dbo.DLK_M_Brand.BrandID = dbo.DLK_M_Sasis.SasisBrandID RIGHT OUTER JOIN dbo.DLK_M_BOMH ON dbo.DLK_M_Sasis.SasisID = dbo.DLK_M_BOMH.BMSasisID WHERE (dbo.DLK_M_BOMH.BMAktifYN = 'Y') AND (dbo.DLK_M_BOMH.BMID = '"& data("BMID") &"') "
set getsasis = data_cmd.execute

%>
<table width="100%">
   <tr>  
      <td colspan="2">No B.O.M</td>
      <td >
         : <%= left(data("BMID"),2) %>-<%= mid(data("BMID"),3,3) %>/<%= mid(data("BMID"),6,4) %>/<%= right(data("BMID"),3) %>
      </td>
      <td colspan="2">Model</td>
      <td >
         : <%= data("Brg_Nama") %>
      </td>
   </tr>
   <tr>
      <td colspan="2">Capaity</td>
      <td >
         : <%= data("capacity") %>
      </td>
      <td colspan="2">Type</td>
      <td >
         : <%= getsasis("type") %>
      </td>
   </tr>
   <tr>
      <td colspan="2">Brand</td>
      <td >
         : <%= getsasis("brand") %>
      </td>
       <td colspan="2">No.Drawing</td>
      <td >
         : <% if getsasis("drawing") <> "" then %> <%= LEft(getsasis("drawing"),5) &"-"& mid(getsasis("drawing"),6,4) &"-"& right(getsasis("drawing"),3) %> <%end if%>
      </td>
   </tr>
   <tr>
      <td style="background-color: #0000a0;color:#fff;">
         No
      </td>
      <td style="background-color: #0000a0;color:#fff;">
         Kategori
      </td>
      <td style="background-color: #0000a0;color:#fff;">
         Jenis
      </td>
      <td style="background-color: #0000a0;color:#fff;">
         Model
      </td>
      <td style="background-color: #0000a0;color:#fff;">
         Quantity
      </td>
      <td style="background-color: #0000a0;color:#fff;">
         Satuan
      </td>
   </tr>
   <% 
   no = 0
   do while not dbom.eof 
   no = no + 1
   %>
   <tr>
      <td>
         <%= no %> 
      </td>
      <td>
         <%=  dbom("kategoriNama") %> 
      </td>
      <td>
         <%=  dbom("jenisNama") %> 
      </td>
      <td>
         <%= dbom("Brg_Nama") %> 
      </td>
      <td>
         <%= ceil(dbom("BMDQtty") * data("capacity")) %> 
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