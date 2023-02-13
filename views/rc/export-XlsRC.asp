<!--#include file="../../init.asp"-->
<% 
   if session("PP1D") = false then
      Response.Redirect("index.asp")
   end if
   id = trim(Request.QueryString("id"))

   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=Material Receipt Produksi "& left(id,2) &"-"& mid(id,2,4) &"-"& right(id,4)&" .xls"


   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' get data header
   data_cmd.commandText = "SELECT dbo.DLK_T_RcProdH.*, dbo.DLK_M_WebLogin.username FROM dbo.DLK_T_RcProdH LEFT OUTER JOIN dbo.DLK_M_Weblogin ON dbo.DLK_T_RcProdH.RC_UpdateID = dbo.DLK_M_webLogin.userID WHERE RC_AktifYN = 'Y' AND RC_ID = '"& id &"'"

   set data = data_cmd.execute

   ' get data detail
   data_cmd.commandText = "SELECT dbo.DLK_T_RCProdD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_RCProdD LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_RCProdD.RCD_SatID = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_RCProdD.RCD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId WHERE LEFT(dbo.DLK_T_RCProdD.RCD_ID,10) = '"& data("RC_ID") &"' ORDER BY Brg_nama ASC"

   set ddata = data_cmd.execute

   ' get data bom 
   data_cmd.commandText = "SELECT ISNULL(dbo.DLK_M_Brand.BrandName,'') as brand, ISNULL(dbo.DLK_M_Class.ClassName,'') as class, ISNULL(dbo.DLK_M_Sasis.SasisType,'') as type FROM dbo.DLK_M_BOMH INNER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID INNER JOIN dbo.DLK_M_Brand INNER JOIN dbo.DLK_M_Sasis INNER JOIN dbo.DLK_M_Class ON dbo.DLK_M_Sasis.SasisClassID = dbo.DLK_M_Class.ClassID ON dbo.DLK_M_Brand.BrandID = dbo.DLK_M_Sasis.SasisBrandID ON dbo.DLK_M_BOMH.BMSasisID = dbo.DLK_M_Sasis.SasisID WHERE (dbo.DLK_T_ProduksiD.PDD_ID = '"& data("RC_PDDID") &"')"
   
   set getsasis = data_cmd.execute

   ' get jenis satuan
   data_cmd.commandText = "SELECT Sat_ID,Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

   set psatuan = data_cmd.execute

   call header("export Transaksi")
%>
<table style="width:100%">
   <tr>
      <td align="center" colspan="6"><b>DETAIL TRANSAKSI PENERIMAAN BARANG PRODUKSI</b></td>
   </tr>
   <tr>
      <td align="center" colspan="6"><b><%= left(id,2) &"-"& mid(id,2,4) &"-"& right(id,4) %></b></td>
   </tr>
   <tr>
      <td>
         Tanggal
      </td>
      <td colspan="2">
         : <%=cdate(data("RC_Date")) %>
      </td>
      <td>
         No Produksi
      </td>
      <td colspan="2">
         : <%=  left(data("RC_PDDid"),2)&"-"&mid(data("RC_PDDid"),3,3) &"/"& mid(data("RC_PDDid"),6,4) &"/"& mid(data("RC_PDDid"),10,4) &"/"& right(data("RC_PDDid"),3) %>
      </td>
   </tr>
   <tr>
      <td>
         Man Power
      </td>
      <td colspan="2">
         : <%= data("RC_MP") %> 
      </td>
      <td>
         Update ID
      </td>
      <td colspan="2">
         :<%= data("username") %>
      </td>
   </tr>
   <tr>
      <td>
         Class 
      </td>
      <td colspan="2">
         :  <% if not getsasis.eof then %>
            <%= getsasis("class") %> 
            <% end if %>
      </td>
      <td>
         Brand
      </td>
      <td colspan="2">
         : <% if not getsasis.eof then %>
         <%= getsasis("Brand") %> 
         <% end if %>
      </td>
   </tr>
   <tr>
      <td>
         Type
      </td>
      <td colspan="2">
         : <% if not getsasis.eof then %>
         <%= getsasis("type") %> 
         <% end if %>
      </td>
      <td>
         Keterangan
      </td>
      <td colspan="2">
         : <%= data("RC_keterangan") %>
      </td>
   </tr> 
   <tr> 
      <td colspan="4">&nbsp</td> 
   </tr> 
</table>
<table style="width:100%">
   <tr>
      <th style="background-color: #0000a0;color:#fff;">Tanggal</th>
      <th style="background-color: #0000a0;color:#fff;">Kode</th>
      <th style="background-color: #0000a0;color:#fff;">Item</th>
      <th style="background-color: #0000a0;color:#fff;">Quantity</th>
      <th style="background-color: #0000a0;color:#fff;">Satuan</th>
      <th style="background-color: #0000a0;color:#fff;">Penerima</th>
   </tr>
   <% 
   do while not ddata.eof 
   %>
      <tr>
         <th>
            <%= Cdate(ddata("RCD_Date")) %>
         </th>
         <th>
            <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
         </th>
         <td>
            <%= ddata("Brg_Nama") %>
         </td>
         <td>
            <%= ddata("RCD_qtysatuan") %>
         </td>
         <td>
            <%= ddata("Sat_nama") %>
         </td>
         <td>
            <%= ddata("RCD_Received") %>
         </td>
      </tr>
   <% 
   ddata.movenext
   loop
   %>
</table>
<% call footer() %>