<!--#include file="../../init.asp"-->
<% 
   if session("INV2D") = false then
      Response.Redirect("./")
   end if
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' header
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_WebLogin.username, DLK_M_Vendor.ven_nama FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptH.MR_UpdateID = DLK_M_Weblogin.userid LEFT OUTER JOIN DLK_M_vendor ON DLK_T_MaterialReceiptH.MR_Venid = DLK_M_Vendor.ven_ID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') AND (dbo.DLK_T_MaterialReceiptH.MR_ID = '"& id &"')"

   set data = data_cmd.execute

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
   .legalitas{
      font-size:12px;
      display:flex;
      justify-content:space-between;
      padding:10px;
   }
   .titiktitik{
      display:flex;
      justify-content:space-between;
      padding:10px;
      margin-top:40px;
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
         <td align="center">FORM PROSES INCOMMING DETAIL</td>
      </tr>
      <tr>
         <td align="center">
           <%= LEFT(data("MR_ID"),2) &"-"& mid(data("MR_ID"),3,3) &"/"& mid(data("MR_ID"),6,4) &"/"& right(data("MR_ID"),4)%>
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
            No. Purchase
         </th>
         <td>
            : <%= left(data("MR_OPHID"),2) %>-<%= mid(data("MR_OPHID"),3,3)%>/<%= mid(data("MR_OPHID"),6,4) %>/<%= right(data("MR_OPHID"),4) %>
         </td>
         <th>
            Vendor
         </th>
         <td>
            : <%= data("ven_nama") %>
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
            <th scope="col">No</th>
            <th scope="col">Diterima</th>
            <th scope="col">Kategori</th>
            <th scope="col">Jenis</th>
            <th scope="col">Barang</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">Rak</th>
            <th scope="col">Total</th>
         </tr>
      </thead>
      <tbody>
         <% 
         ' detail2
         data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptD2.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, DLK_M_Rak.Rak_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama, (DLK_T_OrpemD.OPD_Harga) as hargabeli FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialReceiptD2.MR_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_MaterialReceiptD2.MR_RakID = DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN DLK_T_OrpemD ON DLK_T_MaterialReceiptD2.MR_OPDOPHID = DLK_T_OrpemD.OPD_OPHID WHERE dbo.DLK_T_MaterialReceiptD2.MR_ID = '"& id &"' AND LEFT(MR_OPDOPHID,13) = '"& data("MR_OPHID") &"' AND MR_qtysatuan <> 0"
         set data2 = data_cmd.execute
         
         gtotal = 0
         total = 0
         no = 0
         do while not data2.eof 
         dim x
            no = no + 1
            total = (data2("hargabeli") * data2("MR_Qtysatuan"))

            gtotal = gtotal + total
         %>
         <tr>
            <td><%= no %></td>
            <td><%= data2("MR_AcpDate") %></td>
            <td><%= data2("kategoriNama") %></td>
            <td><%= data2("jenisNama") %></td>
            <td><%= data2("Brg_Nama") %></td>
            <td><%= data2("MR_Qtysatuan") %></td>
            <td><%= data2("Sat_nama") %></td>
            <td><%= replace(formatCurrency(data2("hargabeli")),"$","") %></td>
            <td><%= data2("Rak_nama") %></td>
            <td><%= replace(formatCurrency(total),"$","") %></td>
         </tr>
         <% 
         response.flush
         data2.movenext
         loop
         data2.movefirst
         %>
         <tr>
            <th colspan="9">
               Grand Total
            </th>
            <th>
               <%= replace(formatCurrency(gtotal),"$","") %>
            </th>
         </tr>
      </tbody>
   </table>
   <footer id="pageFooter">
      <div class='legalitas'>
         <p><b>Dibuat Oleh</b></p>
         <p><b>Di Setujui Oleh</b></p>
         <p><b>Mengetahui</b></p>
      </div>
      <div class='titiktitik'>
         <p><b>...................</b></p>
         <p><b>...................</b></p>
         <p><b>...................</b></p>
      </div>
   </footer>
</body>
<% 
   call footer()
%>