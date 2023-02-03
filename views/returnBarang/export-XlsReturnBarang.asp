<!--#include file="../../init.asp"-->
<% 
   if session("PR5D") = false then
      Response.Redirect("index.asp")
   end if
    id = trim(Request.querystring("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_ReturnBarangH.*, DLK_M_Vendor.*, GLB_M_Agen.AgenName FROM DLK_T_ReturnBarangH LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_ReturnBarangH.RB_VenID = DLK_M_Vendor.Ven_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ReturnBarangH.RB_AgenID = GLB_M_Agen.AgenID WHERE RB_ID = '"& id &"'"

    set data = data_cmd.execute 

    ' detail barang
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_ReturnBarangD.* FROM dbo.DLK_T_ReturnBarangD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_ReturnBarangD.RBD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ReturnBarangD.RBD_Item = dbo.DLK_M_Barang.Brg_Id ORDER BY DLK_T_ReturnBarangD.RBD_RBID ASC"

    set detail = data_cmd.execute


    ' data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_T_InvPemD.IPD_RakID FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_VenId = '"& data("RB_VenID") &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("RB_AgenID") &"')ORDER BY dbo.DLK_T_InvPemH.IPH_Date"

    ' set brgVendor = data_cmd.execute

    call header("Detail Return Barang")
%>
<style type="text/css">
   body{
      padding:10px;
   }
   .gambar{
      width:80px;
      height:80px;
      position:absolute;
      right:70px;
   }
   .gambar img{
      position:absolute;
      width:100px;
      height:50px;
   }
   #cdetail > * > tr > *  {
      border: 1px solid black;
      padding:5px;
   }

   #cdetail{
      width:100%;
      font-size:12px;
      border-collapse: collapse;
   }
   .footer article{
      font-size:10px;
   }
   @page {
      size: A4;
      size: auto;   /* auto is the initial value */
      margin: 0;  /* this affects the margin in the printer settings */
   }
   @media print {
      html, body {
         width: 210mm;
         height: 200mm;
         margin:0 auto;
      }
      /* ... the rest of the rules ... */
   }
</style>
<body onload="window.print()">
   <div class="row gambar">
      <div class="col ">
         <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
      </div>
   </div>
   <table width="100%" >
      <tr>
         <td style="text-align:center;">
            <h3>DETAIL RETURN BARANG</h3>
         </td>
      </tr>
      <tr>
         <td style="text-align:center;">
            <h3><%= id %></h3>
         </td>
      </tr>
      <tr><td>&nbsp</td></tr>
   </table>
   <table width="100%" style="font-size:12px">
      <tr>
         <th>No</th>
         <td>
            : <%= data("RB_ID") %>
         </td>
         <th>Cabang / Agen</th>
         <td>
            : <%= data("AgenName") %>
         </td>
      </tr>
      <tr>
         <th>Vendor</th>
         <td>
            : <%= data("Ven_Nama") %>
         </td>
         <th>Tanggal</th>
         <td>
            : <%= Cdate(data("RB_Date")) %>
         </td>
      </tr>
      <tr>
         <th>Phone</th>
         <td>
            : <%= data("Ven_Phone") %>
         </td>
         <th>Email</th>
         <td>
            : <%= data("Ven_Email") %>
         </td>
      </tr>
      <tr>
         <th>Keterangan</th>
         <td>
            : <%= data("RB_Keterangan") %>
         </td>
      </tr>
      <tr>
         <td colspan="5">&nbsp</td>
      </tr>
   </table>
   <!-- content detail -->
   <table id="cdetail" >
      <tr>
         <th scope="col">ID</th>
         <th scope="col">No Transaksi</th>
         <th scope="col">Barang</th>
         <th scope="col">Quantity</th>
         <th scope="col">Satuan</th>
         <th scope="col">Harga</th>
         <th scope="col">PPN</th>
         <th scope="col">Disc1</th>
         <th scope="col">Disc2</th>
      </tr>
      <% 
      do while not detail.eof 
      %>
      <tr>
         <th scope="row"><%= detail("RBD_RBID") %></th>
         <td>
               <%= detail("RBD_IPDIPHID") %>
         </td>
         <td><%= detail("Brg_Nama") %></td>
         <td><%= detail("RBD_Qtysatuan") %></td>
         <td><%= detail("sat_nama") %></td>
         <td>
               <%= replace(formatCurrency(detail("RBD_Harga")),"$","") %>
         </td>
         <td><%= detail("RBD_PPN") %></td>
         <td><%= detail("RBD_Disc1") %></td>
         <td><%= detail("RBD_Disc2") %></td>
      </tr>
      <% 
      response.flush
      detail.movenext
      loop
      %>
   </table>
   <div class="footer">
      <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" width="60"/></br>
      <article>
         <p>
            PT.Delima Karoseri Indonesia
         </p>
         <p>
            Copyright © 2022, ALL Rights Reserved MuhamadFirdaus-IT Division</br>
            V.1 Mobile Responsive 2022
         </p>
      </article>
   </div>  
<% 
    call footer()
%>
