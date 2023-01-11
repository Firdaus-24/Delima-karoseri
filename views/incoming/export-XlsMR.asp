<!--#include file="../../init.asp"-->
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' header
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_WebLogin.username FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptH.MR_UpdateID = DLK_M_Weblogin.userid LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') AND (dbo.DLK_T_MaterialReceiptH.MR_ID = '"& id &"')"

   set data = data_cmd.execute
   ' detail1
   data_cmd.commandTExt = "SELECT DLK_T_MaterialReceiptD1.*, DLK_M_WebLogin.username FROM DLK_T_MaterialReceiptD1 LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptD1.MR_Updateid = DLK_M_Weblogin.userid WHERE MR_ID = '"& id &"'"
   set data1 = data_cmd.execute

   call header("Proses Incomming")
%>
<!--<meta http-equiv="refresh" content="10" />  auto relog page -->
<style type="text/css">
   body{
      padding:10px;
      -webkit-print-color-adjust:exact !important;
      print-color-adjust:exact !important;
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
   <table width="100%">
      <tr>
         <td align="center"><h3>FORM PROSES INCOMMING DETAIL</h3></td>
      </tr>
      <tr>
         <td>
            &nbsp
         </td>
      </tr>
   </table>
   <table width="100%" style="font-size:12px">
      <tr>
         <th>
            Cabang / Agen
         </th>
         <td>
            : <%= data("AgenName") %>
         </td>
         <th>
            Tanggal
         </th>
         <td>
            : <%= Cdate(data("MR_Date")) %>
         </td>
      </tr>
      <tr>
         <th>
            Update ID
         </th>
         <td>
            : <%= data("username") %>
         </td>
         <th>
            Type
         </th>
         <td>
            :  <% if data("MR_Type") = 1 then %>Purchase <% else %>Produksi <% end if %> 
         </td>
      </tr>
      <tr>
            <th>
            Keterangan
         </th>
         <td>
            : <%= data("MR_Keterangan") %>
         </td>
      </tr>
      <tr>
         <td>
            &nbsp
         </td>
      </tr>
   </table>
   <table id="cdetail">
      <thead>
         <tr style="background-color: gray;color:#fff;">
            <th scope="col">No Transaksi</th>
            <th scope="col">Items</th>
            <th scope="col">Quantity</th>
            <th scope="col">Harga</th>
            <th scope="col">Satuan</th>
         </tr>
      </thead>
      <tbody>
         <% 
         do while not data1.eof 
         %>
         <tr style="background-color: blue;color:#fff;">
            <td>Document</td>
            <td><%= data1("MR_Transaksi") %></td>
            <td><%= data1("MR_Updatetime") %></td>
            <td colspan="2"><%= data1("username") %></td>
         </tr>
         <% 
         ' detail2
         data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptD2.MR_Transaksi, dbo.DLK_T_MaterialReceiptD2.MR_Item,dbo.DLK_T_MaterialReceiptD2.MR_Qtysatuan, dbo.DLK_T_MaterialReceiptD2.MR_Harga, dbo.DLK_T_MaterialReceiptD2.MR_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialReceiptD2.MR_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE dbo.DLK_T_MaterialReceiptD2.MR_ID = '"& id &"' AND LEFT(MR_Transaksi,13) = '"& data1("MR_Transaksi") &"' GROUP BY dbo.DLK_T_MaterialReceiptD2.MR_Transaksi, dbo.DLK_T_MaterialReceiptD2.MR_Item,dbo.DLK_T_MaterialReceiptD2.MR_Qtysatuan, dbo.DLK_T_MaterialReceiptD2.MR_Harga, dbo.DLK_T_MaterialReceiptD2.MR_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id ORDER BY dbo.DLK_T_MaterialReceiptD2.MR_Transaksi"
         set data2 = data_cmd.execute
         do while not data2.eof 
         %>
         <tr>
            <td><%= data2("MR_Transaksi") %></td>
            <td><%= data2("Brg_Nama") %></td>
            <td><%= data2("MR_Qtysatuan") %></td>
            <td><%= replace(formatCurrency(data2("MR_Harga")),"$","") %></td>
            <td><%= data2("Sat_nama") %></td>
         </tr>
         <% 
         response.flush
         data2.movenext
         loop
         %>
         <% 
         response.flush
         data1.movenext
         loop
         %>
      </tbody>
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
</body>
<% 
   call footer()
%>