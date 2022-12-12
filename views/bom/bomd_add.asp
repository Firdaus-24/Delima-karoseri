<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_BOM.asp"-->
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_T_BOMH.BMH_ID, dbo.DLK_T_BOMH.BMH_AgenID, dbo.DLK_T_BOMH.BMH_Date, dbo.DLK_T_BOMH.BMH_PDID, dbo.DLK_T_BOMH.BMH_Day, dbo.DLK_T_BOMH.BMH_Month, dbo.DLK_T_BOMH.BMH_Keterangan,dbo.DLK_T_BOMH.BMH_Approve1, dbo.DLK_T_BOMH.BMH_Approve2, dbo.DLK_T_BOMH.BMH_AktifYN, dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName, dbo.DLK_T_ProductH.PDID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_M_Barang INNER JOIN dbo.DLK_T_ProductH ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_ProductH.PDBrgID RIGHT OUTER JOIN dbo.DLK_T_BOMH ON dbo.DLK_T_ProductH.PDID = dbo.DLK_T_BOMH.BMH_PDID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMH.BMH_AgenID = dbo.GLB_M_Agen.AgenID WHERE dbo.DLK_T_BomH.BMH_ID = '"& id &"' AND dbo.DLK_T_BomH.BMH_AktifYN = 'Y'"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   ' getbarang by detail
   data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_BOMD.BMD_ID, dbo.DLK_T_BOMD.BMD_Item, dbo.DLK_T_BOMD.BMD_Qtysatuan, dbo.DLK_T_BOMD.BMD_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_BOMD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMD.BMD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_BOMD.BMD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID INNER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_T_BOMD.BMD_ID, 13) = '"& data("BMH_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
   ' response.write data_cmd.commandText & "<br>"
   set barang = data_cmd.execute
   
   call header("Detail B.O.M")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12 mt-3 text-center">
         <h3>DETAIL FORM B.O.M</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 mb-3 text-center labelId">
         <h3><%= data("BMH_ID") %></h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-2 mb-3">
         <label for="agen" class="col-form-label">Cabang / Agen</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" class="form-control" name="lagen" id="lagen" value="<%= data("AgenName") %>" readonly>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="nopd" class="col-form-label">No Produksi</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="nopd" name="nopd" class="form-control" value="<%= data("BMH_PDID") &" | "& data("brg_nama")%>" readonly>
      </div>
   </div>
   <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
         <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("BMH_date")) %>" readonly required>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="hari" class="col-form-label">Capacity Day</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="hari" name="hari" class="form-control" value="<%= data("BMH_Day") %>" readonly>
      </div>
   </div>
   <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
         <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("BMH_Keterangan") %>" autocomplete="off" readonly>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="bulan" class="col-form-label">Capacity Month</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="number" id="bulan" name="bulan" value="<%= data("BMH_Month") %>" class="form-control" readonly>
      </div>
   </div>
   <div class="row">
      <div class="d-flex mb-3">
         <div class="p-2">
         <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
         </div>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12">
         <table class="table table-hover">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">ID</th>
                  <th scope="col">Kode</th>
                  <th scope="col">Item</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Satuan</th>
                  <th scope="col" class="text-center">Aksi</th>
               </tr>
            </thead>
            <tbody>
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
                     <td class="text-center">
                        <div class="btn-group" role="group" aria-label="Basic example">
                        <a href="aktifd.asp?id=<%= barang("BMD_ID") %>&p=bomd_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'DELETE DETAIL BOM')">Delete</a>
                     </td>
                  </tr>
               <% 
               barang.movenext
               loop
               %>
            </tbody>
         </table>
      </div>
   </div>
</div>  
<% 
   if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
      ' call tambahDetailFaktur()
   end if
   call footer()
%>