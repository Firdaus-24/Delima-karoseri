<!--#include file="../../init.asp"-->
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' header
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, dbo.DLK_M_Weblogin.username FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptH.MR_UpdateID = DLK_M_Weblogin.userid LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') AND (dbo.DLK_T_MaterialReceiptH.MR_ID = '"& id &"')"

   set data = data_cmd.execute
   ' detail1
   data_cmd.commandTExt = "SELECT DLK_T_MaterialReceiptD1.*, DLK_M_WebLogin.username FROM DLK_T_MaterialReceiptD1 LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptD1.MR_Updateid = DLK_M_Weblogin.userid WHERE MR_ID = '"& id &"'"
   set data1 = data_cmd.execute
   ' detail2
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptD2.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialReceiptD2.MR_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE dbo.DLK_T_MaterialReceiptD2.MR_ID = '"& id &"'"
   set data2 = data_cmd.execute

   call header("Proses Incomming")
%>
<!--#include file="../../navbar.asp"--> 
<meta http-equiv="refresh" content="10" /> <!-- auto relog page -->  
<div class="container">
   <div class="row">
      <div class="col-lg-12 mt-3 text-center">
         <h3>UPDATE PROSES INCOMMING DETAIL</h3>
      </div>
   </div>
   <div class="row">
        <div class="col-lg-12 text-center labelId">
            <h3><%= data("MR_ID") %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center">
            <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100" />
        </div>
    </div>
   <div class="row">
      <div class="col-lg-2 mb-3">
         <label for="cabang" class="col-form-label">Cabang / Agen</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="cabang" name="cabang" class="form-control" value="<%= data("AgenName") %>" readonly>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("MR_Date")) %>" readonly>
      </div>
   </div>
   <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
         <label for="updateid" class="col-form-label">Update ID</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="updateid" name="updateid" class="form-control" value="<%= data("username") %>" readonly>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="keterangan" name="keterangan" class="form-control" value="<%= data("MR_Keterangan") %>" autocomplete="off" maxlength="50" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-sm mb-3">
         <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 text-end mb-3">
         <h5>Daftar Document</h5>
      </div>
   </div>   
   <div class="row">
      <div class="col-sm-12 mb-3">
         <table class="table table-striped">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">No</th>
                  <th scope="col">No Transaksi</th>
                  <th scope="col">Update Time</th>
                  <th scope="col">Update ID</th>
                  <th scope="col" class="text-center">Aksi</th>
               </tr>
            </thead>
            <tbody>
               <% 
               no = 0
               do while not data1.eof 
               no = no + 1

               data_cmd.commandTExt = "SELECT MR_ID, MR_Transaksi FROM DLK_T_MaterialReceiptD2 WHERE MR_ID = '"& data1("MR_ID") &"' AND LEFT(MR_Transaksi,13) = '"& data1("MR_Transaksi") &"'"

               set ckdetail1 = data_cmd.execute
               %>
               <tr>
                  <th scope="row"><%= no %></th>
                  <td><%= data1("MR_Transaksi") %></td>
                  <td><%= data1("MR_Updatetime") %></td>
                  <td><%= data1("username") %></td>
                  <td class="text-center">
                  <% if ckdetail1.eof then %>
                     <a href="aktifDetail.asp?id=<%= data1("MR_ID") %>&trans1=<%= data1("MR_Transaksi") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete document material receipt')">delete</a>
                  <% else %>
                     -
                  <% end if %>
                  </td>
               </tr>
               <% 
               response.flush
               data1.movenext
               loop
               %>
            </tbody>
         </table>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 text-end mb-3">
         <h5>Detail barang</h5>
      </div>
   </div>   
   <div class="row">
      <div class="col-sm-12 mb-3">
         <table class="table table-striped">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">No</th>
                  <th scope="col">No Transaksi</th>
                  <th scope="col">Item</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Harga</th>
                  <th scope="col">Satuan</th>
                  <th scope="col" class="text-center">Aksi</th>
               </tr>
            </thead>
            <tbody>
               <% 
               no1 = 0
               do while not data2.eof 
               no1 = no1 + 1
               %>
               <tr>
                  <th scope="row"><%= no1 %></th>
                  <td><%= data2("MR_Transaksi") %></td>
                  <td><%= data2("Brg_Nama") %></td>
                  <td><%= data2("MR_Qtysatuan") %></td>
                  <td><%= replace(formatCurrency(data2("MR_Harga")),"$","") %></td>
                  <td><%= data2("Sat_nama") %></td>
                  <td class="text-center">
                     <a href="aktifDetail.asp?id=<%= data2("MR_ID") %>&trans2=<%= data2("MR_Transaksi") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete item material receipt')">delete</a>
                  </td>
               </tr>
               <% 
               response.flush
               data2.movenext
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