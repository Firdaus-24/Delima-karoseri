<!--#include file="../../init.asp"-->
<% 
   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=FakturTerhutang.xls"

   tgla = trim(Request.queryString("la"))
   tgle = trim(Request.queryString("le"))
   agen = trim(Request.queryString("en"))
   vendor = trim(Request.queryString("or"))

   if agen <> "" then
      filterAgen = "AND DLK_T_InvPemH.IPH_AgenID = '"& agen &"'"
   else
      filterAgen = ""
   end if

   if vendor <> "" then
      filtervendor = "AND dbo.DLK_T_InvPemH.IPH_VenID = '"& vendor &"'"
   else
      filtervendor = ""
   end if

   if tgla <> "" AND tgle <> "" then
      filtertgl = "AND dbo.DLK_T_InvPemH.IPH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
   elseIf tgla <> "" AND tgle = "" then
      filtertgl = "AND dbo.DLK_T_InvPemH.IPH_Date = '"& tgla &"'"
   else 
      filtertgl = ""
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandTExt = "SELECT DLK_T_InvPemH.*, GLB_M_Agen.AgenName, DLK_M_Vendor.Ven_Nama FROM DLK_T_InvPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_InvPemH.IPH_venID = DLK_M_Vendor.Ven_ID WHERE IPH_AktifYN = 'Y' "& filterAgen &"  "& filtervendor &" "& filtermetpem &" "& filtertgl &" ORDER BY IPH_Date ASC"

   set data = data_cmd.execute

   if agen <> "" then
      pagen = " CABANG "& data("AgenName")
   else
      pagen = ""
   end if

   if vendor <> "" then
      pvendor = " VENDOR "& data("Ven_Nama")
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

   strhader = "LAPORAN FAKTUR PEMBELIAN "& pagen & pvendor & ptgl 

   call header("Laporan Faktur Pembelian")
%>
<body>
<div class="container">
   <div class="row">
      <div class="col-lg-12">
         <table class="table table-hover">
            <thead >
               <tr>
                  <th colspan="8" style="text-align:center;"><b><%= strhader %></b></th>
               </tr>
               <tr>
                  <th style="background-color: #0000a0;color:#fff;">No</th>
                  <th style="background-color: #0000a0;color:#fff;">Barang</th>
                  <th style="background-color: #0000a0;color:#fff;">Quantity</th>
                  <th style="background-color: #0000a0;color:#fff;">Satuan</th>
                  <th style="background-color: #0000a0;color:#fff;">Disc 1</th>
                  <th style="background-color: #0000a0;color:#fff;">Disc 2</th>
                  <th style="background-color: #0000a0;text-align: center;color:#fff;">Harga</th>
                  <th style="background-color: #0000a0;text-align: center;color:#fff;">Total</th>
               </tr>
            </thead>
            <tbody>
               <% 
               'prints records in the table
               subtotal = 0
               ppn = 0
               diskonall = 0
               grandtotal = 0
               do while not data.eof 
               data_cmd.commandTExt = "SELECT DLK_T_InvPemD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_InvPemD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_InvPemD.IPD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(IPD_IphID,13) = '"& data("IPH_ID") &"'"
               set p = data_cmd.execute
               %>
                  <tr>
                  <th colspan="2" style="background-color:#ffff00;"><%= data("IPH_ID") %></th>
                  <td style="background-color:#ffff00;"><%= data("AgenNAme")%></td>
                  <td style="background-color:#ffff00;"><%= Cdate(data("IPH_Date")) %></td>
                  <td style="background-color:#ffff00;">
                        <% if data("IPH_JTDate") <> "1900-01-01" then %>
                        <%= Cdate(data("IPH_JTDate")) %>
                        <% end if %>
                  </td>
                  <td colspan="3" style="background-color:#ffff00;"><%= data("Ven_Nama") %></td>
               </tr>
               <% 
               no = 0
               disc1 = 0
               disc2 = 0
               tharga = 0
               total = 0
               do while not p.eof 
               no = no + 1

               if p("IPD_Disc1") <> 0 then
                  disc1 = Round((p("IPD_Harga") * p("IPD_Qtysatuan")) / (p("IPD_Disc1") / 100))
               else
                  disc1 = 0
               end if

               if p("IPD_Disc2") <> 0 then
                  disc2 = Round((p("IPD_Harga") * p("IPD_Qtysatuan")) / (p("IPD_Disc2") / 100))
               else
                  disc2 = 0
               end if

               tharga = (p("IPD_Harga") * p("IPD_Qtysatuan")) - disc1 - disc2
               total = total + tharga
               %>
               <tr>
                  <td><%= no %></td>
                  <td><%= p("Brg_Nama") %></td>
                  <td><%= p("IPD_Qtysatuan") %></td>
                  <td><%= p("sat_nama") %></td>
                  <td><%= p("IPD_Disc1") %></td>
                  <td><%= p("IPD_Disc2") %></td>
                  <td align="right"><%= replace(formatCurrency(p("IPD_Harga")),"$","") %></td>
                  <td align="right"><%= replace(formatCurrency(tharga),"$","") %></td>
               </tr>
               <% 
               response.flush
               p.movenext
               loop

               ' cek diskonall
               if data("IPH_diskonall") <> 0 OR data("IPH_Diskonall") <> "" then
                  diskonall = Round((data("IPH_Diskonall")/100) * total)
               else
                  diskonall = 0
               end if

               ' hitung ppn
               if data("IPH_ppn") <> 0 OR data("IPH_ppn") <> "" then
                  ppn = Round((data("IPH_ppn")/100) * total)
               else
                  ppn = 0
               end if 

               subtotal = (total + ppn) - diskonall 'sub total pembelian
               grandtotal = grandtotal + subtotal 'gran total pembelian
               %>
               <tr>
                  <th align="left" colspan="6">PPN</th>
                  <td align="right"><%= data("IPH_PPN") %>%</td>
                  <td align="right"><%= replace(formatcurrency(ppn),"$","") %></td>
               </tr>
               <tr>
                  <th align="left" colspan="6">Diskon All</th>
                  <td align="right"><%= data("IPH_DiskonAll") %>%</td>
                  <td align="right"><%= replace(formatcurrency(diskonall),"$","") %></td>
               </tr>
               <tr>
                  <th align="left" colspan="7">Sub Total</th>
                  <td align="right"><%= replace(formatcurrency(subtotal),"$","") %></td>
               </tr>
               <% 
               response.flush
               data.movenext
               loop
               %>
               <!-- cek grand total -->
               <tr>
                  <th align="left" colspan="7">
                     Grand Total
                  </th>
                  <td align="right">
                     <%= replace(formatcurrency(grandtotal),"$","") %>
                  </td>
               </tr>
            </tbody>
         </table>
      </div>
   </div> 
</div>

<% call footer() %>