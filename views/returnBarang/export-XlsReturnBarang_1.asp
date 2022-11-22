<!--#include file="../../init.asp"-->
<% 
   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=ReturnBarang.xls"

   tgla = trim(Request.queryString("la"))
   tgle = trim(Request.queryString("le"))
   agen = trim(Request.queryString("en"))
   vendor = trim(Request.queryString("or"))

   if agen <> "" then
      filterAgen = "AND DLK_T_ReturnBarangH.RB_AgenID = '"& agen &"'"
   else
      filterAgen = ""
   end if

   if vendor <> "" then
      filtervendor = "AND dbo.DLK_T_ReturnBarangH.RB_VenID = '"& vendor &"'"
   else
      filtervendor = ""
   end if

   if tgla <> "" AND tgle <> "" then
      filtertgl = "AND dbo.DLK_T_ReturnBarangH.RB_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
   elseIf tgla <> "" AND tgle = "" then
      filtertgl = "AND dbo.DLK_T_ReturnBarangH.RB_Date = '"& tgla &"'"
   else 
      filtertgl = ""
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")

   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT DLK_T_ReturnBarangH.*, GLB_M_Agen.AgenNAme, DLK_M_Vendor.Ven_Nama FROM DLK_T_ReturnBarangH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ReturnBarangH.RB_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_ReturnBarangH.RB_VenID = DLK_M_Vendor.Ven_ID WHERE RB_AktifYN = 'Y' "& filterAgen &" "& filtervendor &" "& filtertgl &" ORDER BY RB_Date DESC"

   set rs = data_cmd.execute

   if agen <> "" then
      pagen = " CABANG "& rs("AgenName")
   else
      pagen = ""
   end if

   if vendor <> "" then
      pvendor = " VENDOR "& rs("Ven_Nama")
   else
      pvendor = ""
   end if

   if tgla <> "" AND tgle <> "" then
      ptgl = " PRIODE "& tgla & " - " & tgle
   elseIf tgla <> "" AND tgle = "" then
      ptgla = " PRIODE "& tgla 
   else
      ptgl = ""
   end if
   strhader = "RETURN BARANG "& pagen & pvendor & ptgl

   call header("Return Barang")
%>
<table class="table">
   <tr>
      <td align="center" colspan="9" >
         <b><%= strhader %></b>
      </td>
   </tr>
   <tr>
      <th scope="col" style="background-color: #0000a0;color:#fff;">No</th>
      <th scope="col" style="background-color: #0000a0;color:#fff;">Barang</th>
      <th scope="col" style="background-color: #0000a0;color:#fff;">Quantity</th>
      <th scope="col" style="background-color: #0000a0;color:#fff;">Satuan</th>
      <th scope="col" style="background-color: #0000a0;color:#fff;">PPN</th>
      <th scope="col" style="background-color: #0000a0;color:#fff;">Disc1</th>
      <th scope="col" style="background-color: #0000a0;color:#fff;">Disc2</th>
      <th scope="col" style="background-color: #0000a0;color:#fff;">Harga</th>
      <th scope="col" style="background-color: #0000a0;color:#fff;">Total</th>
   </tr>
   <% 
   'prints records in the table
   grandtotal = 0
   do while not rs.eof
   ' cek data detail
   data_cmd.commandText = "SELECT DLK_T_ReturnBarangD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_ReturnBarangD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_ReturnBarangD.RBD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_satuanBarang ON DLK_T_ReturnBarangD.RBD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(RBD_RBID,12) = '"& rs("RB_ID") &"'"

   set detail = data_cmd.execute
   %>
   <tr>
      <td colspan="9" style="background-color:#ffff00;">Tgl : <%= Cdate(rs("RB_Date")) %> | Cabang :  <%= rs("AgenNAme") %> | Vendor : <%= rs("Ven_Nama") %></td>
   </tr>
   <!-- detail content -->
   <% 
   no = 0
   total = 0
   ppn = 0
   subtotal = 0
   do while not detail.eof 
   no = no + 1

   tharga = detail("RBD_Harga") * detail("RBD_Qtysatuan")
   ppn = tharga * (detail("RBD_PPn") / 100)

   if detail("RBD_Disc1") <> 0 then
     disc1 = Round(tharga / (detail("RBD_Disc1") / 100))
   else
      disc1 = 0
   end if
   
   if detail("RBD_Disc2") <> 0 then
     disc2 = Round(tharga / (detail("RBD_Disc2") / 100))
   else
      disc2 = 0
   end if

   total = Round(tharga + ppn - disc1 - disc2)
   %>
   <tr>
      <td><%= no %></td>
      <td><%= detail("Brg_Nama") %></td>
      <td><%= detail("RBD_Qtysatuan") %></td>
      <td><%= detail("Sat_Nama") %></td>
      <td><%= detail("RBD_PPN") %>%</td>
      <td><%= detail("RBD_Disc1") %>%</td>
      <td><%= detail("RBD_Disc2") %>%</td>
      <td align="right"><%= replace(formatCurrency(detail("RBD_Harga")),"$","") %></td>
      <td align="right"><%= replace(formatCurrency(total),"$","") %></td>
   </tr>
   <% 
   ' cek sub total
   subtotal = subtotal + total

   response.flush
   detail.movenext
   loop  %>
   <tr>
      <td colspan="8">
         Sub Total
      </td>
      <td align="right"><%= replace(formatCurrency(subtotal),"$","") %></td>
   </tr>
   <% 
   ' cek grandtotal
   grandtotal = grandtotal + subtotal

   response.flush
   rs.movenext
   loop
   %>
   <tr>
      <td colspan="7">
         Grand Total
      </td>
      <td>
         <td align="right"><%= replace(formatCurrency(grandtotal),"$","") %></td>
      </td>
   </tr>
</table>
<% call footer %>