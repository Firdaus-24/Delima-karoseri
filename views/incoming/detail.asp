<!--#include file="../../init.asp"-->
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' header
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_T_MaterialReceiptH.MR_Jenis = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') AND (dbo.DLK_T_MaterialReceiptH.MR_ID = '"& id &"')"

   set data = data_cmd.execute
   ' detail1
   data_cmd.commandTExt = "SELECT DLK_T_MaterialReceiptD1.*, DLK_M_WebLogin.username FROM DLK_T_MaterialReceiptD1 LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptD1.MR_Updateid = DLK_M_Weblogin.userid WHERE MR_ID = '"& id &"'"
   set data1 = data_cmd.execute

   call header("Proses Incomming")
%>
<!--#include file="../../navbar.asp"--> 
<!--<meta http-equiv="refresh" content="10" />  auto relog page -->
<style>
$theme-colors: (
  primary: $purple
);
</style>
<div class="container">
   <div class="row">
      <div class="col-lg-12 mt-3 text-center">
         <h3>FORM PROSES INCOMMING DETAIL</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center labelId">
         <h3><%= data("MR_ID") %></h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 mb-3 text-center">
         <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" />
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12">
         <table class="table" style="border:transparent;">
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
                  Type Barang
               </th>
               <td>
                  : <%= data("T_Nama") %>
               </td>
               <th>
                  Keterangan
               </th>
               <td>
                  : <%= data("MR_Keterangan") %>
               </td>
            </tr>
         </table>
      </div>
   </div>
   <div class="row">
      <div class="d-flex mb-3">
         <div class="me-auto p-2">
            <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsMR.asp?id=<%=id%>','_self')">EXPORT</button>
         </div>
         <div class="p-2">
            <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
         </div>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 mb-3">
         <table class="table">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">No Transaksi</th>
                  <th scope="col">Items</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Satuan</th>
               </tr>
            </thead>
            <tbody>
               <% 
               do while not data1.eof 
               %>
               <tr class="bg-primary text-light">
                  <td>Document</td>
                  <td><%= data1("MR_Transaksi") %></td>
                  <td><%= data1("MR_Updatetime") %></td>
                  <td><%= data1("username") %></td>
               </tr>
               <% 
               ' detail2
               data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptD2.MR_Transaksi, dbo.DLK_T_MaterialReceiptD2.MR_Item,dbo.DLK_T_MaterialReceiptD2.MR_Qtysatuan, dbo.DLK_T_MaterialReceiptD2.MR_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialReceiptD2.MR_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE dbo.DLK_T_MaterialReceiptD2.MR_ID = '"& id &"' AND LEFT(MR_Transaksi,13) = '"& data1("MR_Transaksi") &"' GROUP BY dbo.DLK_T_MaterialReceiptD2.MR_Transaksi, dbo.DLK_T_MaterialReceiptD2.MR_Item,dbo.DLK_T_MaterialReceiptD2.MR_Qtysatuan, dbo.DLK_T_MaterialReceiptD2.MR_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id ORDER BY dbo.DLK_T_MaterialReceiptD2.MR_Transaksi"
               set data2 = data_cmd.execute
               do while not data2.eof 
               %>
               <tr>
                  <td><%= data2("MR_Transaksi") %></td>
                  <td><%= data2("Brg_Nama") %></td>
                  <td><%= data2("MR_Qtysatuan") %></td>
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
      </div>
   </div>
</div>  

<% 
   call footer()
%>