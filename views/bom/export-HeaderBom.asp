<!--#include file="../../init.asp"-->
<% 

   tgla = trim(Request.QueryString("la"))
   tgle = trim(Request.QueryString("le"))
   agen = trim(Request.QueryString("en"))
   produk = trim(Request.QueryString("or"))

   if agen <> "" then
      filterAgen = "AND DLK_T_BOMH.BMH_AgenID = '"& agen &"'"
   else
      filterAgen = ""
   end if

   if produk <> "" then
      filterproduk = "AND dbo.DLK_T_BOMH.BMH_PDID = '"& produk &"'"
   else
      filterproduk = ""
   end if

   if tgla <> "" AND tgle <> "" then
      filtertgl = "AND dbo.DLK_T_BOMH.BMH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
   elseIf tgla <> "" AND tgle = "" then
      filtertgl = "AND dbo.DLK_T_BOMH.BMH_Date = '"& tgla &"'"
   else 
      filtertgl = ""
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandTExt = "SELECT dbo.DLK_T_BOMH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_T_ProductH.PDBrgID, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_BOMH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMH.BMH_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_T_ProductH ON dbo.DLK_T_BOMH.BMH_PDID = dbo.DLK_T_ProductH.PDID INNER JOIN DLK_M_Barang ON DLK_T_ProductH.PDBrgID = DLK_M_Barang.Brg_ID WHERE DLK_T_BOMH.BMH_AktifYN = 'Y' "& filterAgen &" "& filterproduk &" "& filtertgl &""

   set data = data_cmd.execute
   
   if agen <> "" then
      stragen = data("agenName")
   else
      stragen = ""
   end if

   if produk <> "" then
      strproduk = data("Brg_Nama")
   else
      strproduk = ""
   end if

   if tgla <> "" AND tgle <> "" then
      strtgl = "PRIODE '"& Cdate(tgla) &"' - '"& Cdate(tgle) &"'"
   elseIf tgla <> "" AND tgle = "" then
      strtgl = "PRIODE '"& Cdate(tgla) &"'"
   else 
      strtgl = ""
   end if

   str = stragen & strproduk & strtgl

   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=FormBom "& str &".xls"

   call header("Media Print")
%>
<style type="text/css">
   body{
      -webkit-print-color-adjust:exact !important;
      print-color-adjust:exact !important;
    }
   #cdetail  {
      background-color:yellow;
   }
   #cdetail1{background-color:blue;color:#fff;}
</style>
<table class="table1">
   <tr>
      <td colspan="8" style="text-align:center;font-size: large;">
         <b>DAFTAR FORM B.O.M</b>
      </td>
   </tr>
   <tr>
      <td colspan="8" align="center">
         <b><%= str %></b>
      </td>
   </tr>
   <tr>
      <th id="cdetail1">No</th>
      <th id="cdetail1">Bom ID</th>
      <th id="cdetail1">Cabang</th>
      <th id="cdetail1">Tanggal</th>
      <th id="cdetail1">Product</th>
      <th id="cdetail1">Approve1</th>
      <th id="cdetail1">Approve2</th>
      <th id="cdetail1">Keterangan</th>
   </tr>
   <% 
   'prints records in the table
   no = 0
   do while not data.eof
   no = no + 1
   data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_BOMD.BMD_ID, dbo.DLK_T_BOMD.BMD_Item, dbo.DLK_T_BOMD.BMD_Qtysatuan, dbo.DLK_T_BOMD.BMD_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_BOMD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMD.BMD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_BOMD.BMD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID INNER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_T_BOMD.BMD_ID, 13) = '"& data("BMH_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
   set p = data_cmd.execute
   %>
   <tr>
      <TH id="cdetail"><%= no %></TH>
      <th id="cdetail"><%= data("BMH_ID") %></th>
      <td id="cdetail"><%= data("AgenNAme")%></td>
      <td id="cdetail"><%= Cdate(data("BMH_Date")) %></td>
      <td id="cdetail"><%= data("Brg_Nama") %></td>
      <td id="cdetail">
         <%= data("BMH_Approve1") %>
      </td>
      <td id="cdetail">
         <%= data("BMH_Approve2") %>
      </td>
      <td id="cdetail"><%= data("BMH_Keterangan") %></td>
   </tr>
   <% do while not p.eof %>
      <tr>
         <td>
         </td>
         <th>
            <%= p("BMD_ID") %>
         </th>
         <th colspan="2">
            <%= p("KategoriNama") &"-"& p("jenisNama") %>
         </th>
         <td>
            <%= p("Brg_Nama") %>
         </td>
         <td colspan="2">
            <%= p("BMD_QtySatuan") %>
         </td>
         <td>
            <%= p("Sat_nama") %>
         </td>
      </tr>
   <% 
      Response.flush
      p.movenext
      loop
   Response.flush
   data.movenext
   loop
   %>
</table>
<% call footer() %>