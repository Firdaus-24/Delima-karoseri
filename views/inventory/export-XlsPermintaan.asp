<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_BOM.asp"-->
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_T_BOMH.BMH_ID, dbo.DLK_T_BOMH.BMH_AgenID, dbo.DLK_T_BOMH.BMH_Date, dbo.DLK_T_BOMH.BMH_PDID, dbo.DLK_T_BOMH.BMH_Day, dbo.DLK_T_BOMH.BMH_StartDate, dbo.DLK_T_BOMH.BMH_Enddate, dbo.DLK_T_BOMH.BMH_Keterangan,dbo.DLK_T_BOMH.BMH_Approve1, dbo.DLK_T_BOMH.BMH_Approve2, dbo.DLK_T_BOMH.BMH_AktifYN, dbo.DLK_T_BOMH.BMH_PrototypeYN, dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_ProductH.PDID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_M_Barang INNER JOIN dbo.DLK_M_ProductH ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_ProductH.PDBrgID RIGHT OUTER JOIN dbo.DLK_T_BOMH ON dbo.DLK_M_ProductH.PDID = dbo.DLK_T_BOMH.BMH_PDID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMH.BMH_AgenID = dbo.GLB_M_Agen.AgenID WHERE dbo.DLK_T_BomH.BMH_ID = '"& id &"' AND dbo.DLK_T_BomH.BMH_AktifYN = 'Y'"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   ' getbarang by vendor
   data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_BOMD.BMD_ID, dbo.DLK_T_BOMD.BMD_Item, dbo.DLK_T_BOMD.BMD_Qtysatuan, dbo.DLK_T_BOMD.BMD_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_BOMD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMD.BMD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_BOMD.BMD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID INNER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_T_BOMD.BMD_ID, 13) = '"& data("BMH_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
   ' response.write data_cmd.commandText & "<br>"
   set barang = data_cmd.execute
   
   call header("Detail B.O.M")
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
            <h5>DETAIL FORM B.O.M</h5>
         </td>
      </tr>
   </table>

   <table width="100%" style="font-size:12px">
      <tr>
         <th>No</th>
         <td>
            : <%= data("BMH_ID") %>
         </td>
         <th>Cabang / Agen</th>
         <td>
            : <%= data("AgenName") %>
         </td>
      </tr>
      <tr>
         <th>No Produksi</th>
         <td>
            : <%= data("BMH_PDID") &" | "& data("brg_nama")%>
         </td>
         <th>Tanggal</th>
         <td>
            : <%= Cdate(data("BMH_date"))%>
         </td>
      </tr>
      <tr>
         <th>Start Date</th>
         <td>
            : <%= Cdate(data("BMH_StartDate"))%>
         </td>
         <th>End Date</th>
         <td>
            : <%= Cdate(data("BMH_Enddate"))%>
         </td>
      </tr>
      <tr>
         <th>Approve 1</th>
         <td>
            : <%if data("BMH_Approve1") = "Y" then %>
               Done
               <% else %>
               Waiting
               <% end if %>   
         </td>
         <th>Approve 2</th>
         <td>
            : <%if data("BMH_Approve2") = "Y" then %>
               Done
               <% else %>
               Waiting
               <% end if %>
         </td>
      </tr>
      <tr>
         <th>Capacity Day</th>
         <td>
            : <%= data("BMH_Day") %>
         </td>
         <th>Prototype</th>
         <td>
            : <%if data("BMH_PrototypeYN") = "Y" then %>
               Yes
            <% else %>
               No
            <% end if %>
         </td>
      </tr>
      <tr>
         <th>Keterangan</th>
         <td>
            : <%= data("BMH_Keterangan") %>
         </td>
      </tr>
      <tr>
         <td>
            &nbsp
         </td>
      </tr>
   </table>
   <table id="cdetail">
      <tr>
         <th scope="col">ID</th>
         <th scope="col">Kode</th>
         <th scope="col">Item</th>
         <th scope="col">Quantity</th>
         <th scope="col">Satuan</th>
      </tr>
         <% 
         do while not barang.eof 
         %>
            <tr>
               <th>
                  <%= barang("BMD_ID") %>
               </th>
               <th>
                  <%= barang("KategoriNama") &"-"& barang("jenisNama") %>
               </th>
               <td>
                  <%= barang("Brg_Nama") %>
               </td>
               <td>
                  <%= barang("BMD_QtySatuan") %>
               </td>
               <td>
                  <%= barang("Sat_nama") %>
               </td>
            </tr>
         <% 
         barang.movenext
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
<% 
   call footer()
%>