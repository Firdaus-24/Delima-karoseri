<!--#include file="../../init.asp"-->
<% 
   if session("ENG1D") = false then
      Response.Redirect("./")
   end if
   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=Produksi "& trim(Request.QueryString("id")) &".xls"

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' header
   data_cmd.commandTExt = "SELECT dbo.DLK_T_ProduksiH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama, dbo.MKT_T_OrJulH.OJH_TimeWork FROM dbo.DLK_M_Customer INNER JOIN dbo.MKT_T_OrJulH ON dbo.DLK_M_Customer.custId = dbo.MKT_T_OrJulH.OJH_CustID RIGHT OUTER JOIN dbo.DLK_T_ProduksiH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ProduksiH.PDH_AgenID = dbo.GLB_M_Agen.AgenID ON dbo.MKT_T_OrJulH.OJH_ID = dbo.DLK_T_ProduksiH.PDH_OJHID WHERE PDH_ID = '"& id &"' AND PDH_AktifYN = 'Y'"

   set data = data_cmd.execute  

   ' get detail produksi
   data_cmd.commandTExt = "SELECT DLK_T_ProduksiD.*,  dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Barang.Brg_Nama FROM DLK_M_Barang RIGHT OUTER JOIN  DLK_T_ProduksiD ON DLK_T_ProduksiD.PDD_Item = DLK_M_Barang.Brg_ID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE LEFT(PDD_ID,13) = '"& data("PDH_ID") &"' ORDER BY PDD_ID ASC"
   ' response.write data_cmd.commandText & "<br>"
   set ddata = data_cmd.execute 

   call header("Form Detail Produksi")
%>
<table style="width:100%">
   <tr>
      <td align="center" colspan="9"><b>FORM DETAIL PRODUKSI</b></td>
   </tr>
   <tr>
      <td align="center" colspan="9"><b><%= left(id,2) %>-<%= mid(id,3,3)%>/<%= mid(id,6,4) %>/<%= right(id,3)  %></b></td>
   </tr>
   <tr>
      <td colspan="2">
         Cabang / Agen
      </td>
      <td colspan="2">
         : <%=data("agenName") %>
      </td>
      <td colspan="2">
         Tanggal
      </td>
      <td colspan="2">
         : <%= Cdate(data("PDH_Date")) %>
      </td>
   </tr>
   <tr>
      <td colspan="2">
         Prototype
      </td>
      <td colspan="2">
         : <% if data("PDH_PrototypeYN") = "Y" then %>Yes <% else %>No <% end if %>
      </td>
      <td colspan="2">
         Model
      </td>
      <td colspan="2">
         : <% if data("PDH_Model") = "L" then %>Leguler <% elseIf data("PDH_Model") = "P" then %>Project <% elseIF data("PDH_Model") = "S" then %>Sub Part<% end if %> 
      </td>
   </tr>
   <tr>
      <td colspan="2">
         Customer
      </td>
      <td colspan="2">
         : <%= data("custNama") %>
      </td>
      <td colspan="2">
         Estimasi Pengerjaan
      </td>
      <td colspan="2">
         : <%= data("OJH_TimeWork") %> Hari 
      </td>
   </tr>
   <tr>
      <td colspan="2">
         Start Date
      </td>
      <td colspan="2">
         : <%= Cdate(data("PDH_startDate")) %>
      </td>
      <td colspan="2">
         End Date
      </td>
      <td >
        : <%= Cdate(data("PDH_EndDate")) %>
      </td>
   </tr>
   <tr>
      <td colspan="2">
         Keterangan
      </td>
      <td colspan="3">
         : <%= data("PDH_Keterangan") %>
      </td>
   </tr> 
   <tr> 
      <td colspan="4">&nbsp</td> 
   </tr> 
</table>
<table style="width:100%">
   <tr>
      <th style="background-color: #0000a0;color:#fff;">No.Produksi</th>
      <th style="background-color: #0000a0;color:#fff;">B.O.M ID</th>
      <th style="background-color: #0000a0;color:#fff;">No. Drawing</th>
      <th style="background-color: #0000a0;color:#fff;">Kategori</th>
      <th style="background-color: #0000a0;color:#fff;">Jenis</th>
      <th style="background-color: #0000a0;color:#fff;">Model</th>
      <th style="background-color: #0000a0;color:#fff;">Type</th>
      <th style="background-color: #0000a0;color:#fff;">Brand</th>
      <th style="background-color: #0000a0;color:#fff;">PPIC</th>
   </tr>
   <% 
   do while not ddata.eof 
   ' cek nomor drawing
   data_cmd.commandTExt = "SELECT ISNULL(dbo.DLK_M_Sasis.SasisType, '') AS type, ISNULL(dbo.DLK_M_Brand.BrandName, '') AS brand, ISNULL(dbo.DLK_M_Sasis.SasisDrawing, '') AS drawing FROM dbo.DLK_M_Brand INNER JOIN dbo.DLK_M_Sasis ON dbo.DLK_M_Brand.BrandID = dbo.DLK_M_Sasis.SasisBrandID RIGHT OUTER JOIN dbo.DLK_M_BOMH ON dbo.DLK_M_Sasis.SasisID = dbo.DLK_M_BOMH.BMSasisID WHERE (dbo.DLK_M_BOMH.BMAktifYN = 'Y') AND (dbo.DLK_M_BOMH.BMID = '"& ddata("PDD_BMID") &"') "
   set getsasis = data_cmd.execute
   %>
      <tr>
         <th>
            <%= left(ddata("PDD_id"),2) %>-<%= mid(ddata("PDD_id"),3,3)%>/<%= mid(ddata("PDD_id"),6,4) %>/<%= mid(ddata("PDD_id"),10,4) %>/<%= right(ddata("PDD_id"),3)  %>
         </th>
         <td>
            <%= left(ddata("PDD_BMID"),2) %>-<%= mid(ddata("PDD_BMID"),3,3)%>/<%= mid(ddata("PDD_BMID"),6,4) %>/<%= right(ddata("PDD_BMID"),3)  %>
         </td>
         <td>
            <% if getsasis("drawing") <> "" then %>
               <%= LEft(getsasis("drawing"),5) &"-"& mid(getsasis("drawing"),6,4) &"-"& right(getsasis("drawing"),3)  %>
            <%  end if %>
         </td>
         <td>
            <%= ddata("KategoriNama") %>
         </td>
         <td>
            <%= ddata("jenisNama") %>
         </td>
         <td>
            <%= ddata("brg_nama")%>
         </td>
         <td>
            <%= getsasis("brand")%>
         </td>
         <td>
            <%= getsasis("type")%>
         </td>
         <td>
            <%= ddata("PDD_PICName")%>
         </td>
      </tr>
   <% 
   ddata.movenext
   loop
   %>
</table>

<% 
   call footer()
%>