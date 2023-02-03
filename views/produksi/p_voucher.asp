<!--#include file="../../init.asp"-->
<% 
   if session("ENG1F") = false then
      Response.Redirect("index.asp")
   end if

   pddid = trim(Request.Form("pddid"))
   vchID = trim(Request.Form("vchID"))
   call header("Print Voucher")

   set data_cmd = Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   x = split(vchID,",")

   dim a
   for each a in x
      ' insert table voucher
      data_cmd.commandText = "SELECT * FROM DLK_T_Voucher WHERE VCH_PDDID = '"& pddid &"' AND VCH_BMDBMID = '"& trim(a) &"' "

      set data = data_cmd.execute

      if data.eof then
         call query("exec sp_addDLK_T_Voucher '"& pddid &"', '"& trim(a) &"', '"& session("userID") &"' ")
      end if   
   response.flush
   next
%>
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
         <td align="center"><b>VOUCHER PERMINTAAN</b></td>
      </tr>
      <tr>
         <td align="center"><b>NO : <%= left(pddid,2) %>-<%= mid(pddid,3,3) %>/<%= mid(pddid,6,4) %>/<%= mid(pddid,10,4) %>/<%= right(pddid,3) %></b></td>
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
            <th scope="col">Kode</th>
            <th scope="col">Nama Barang</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
         </tr>
      </thead>
<% 
   for each a in x 
      ' get value voucher
      data_cmd.commandTExt = "SELECT dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_BOMD.BMDBMID, dbo.DLK_M_BOMD.BMDqtty FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_M_BOMD.BMDJenisSat LEFT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_M_BOMD.BMDItem = dbo.DLK_M_Barang.Brg_Id WHERE (dbo.DLK_M_BOMD.BMDBMID = '"& trim(a) &"')"

      set ddata = data_cmd.execute
%>
      <tr>
         <td><%= ddata("kategoriNama") &"-"& ddata("jenisNama") %></td>
         <td><%= ddata("Brg_Nama") %></td>
         <td><%= ddata("BMDQtty") %></td>
         <td><%= ddata("sat_nama") %></td>
      </tr>
<% 
   next 
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
</body>
<% call footer() %>