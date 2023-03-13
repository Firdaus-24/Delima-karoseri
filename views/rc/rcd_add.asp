<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_RC.asp"--> 
<% 
    if session("PP1A") = false then
        Response.Redirect("index.asp")
    end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' get data header
   data_cmd.commandText = "SELECT dbo.DLK_T_RcProdH.*, dbo.DLK_M_WebLogin.username FROM dbo.DLK_T_RcProdH LEFT OUTER JOIN dbo.DLK_M_Weblogin ON dbo.DLK_T_RcProdH.RC_UpdateID = dbo.DLK_M_webLogin.userID WHERE RC_AktifYN = 'Y' AND RC_ID = '"& id &"'"

   set data = data_cmd.execute

   ' get data detail
   data_cmd.commandText = "SELECT dbo.DLK_T_RCProdD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_RCProdD LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_RCProdD.RCD_SatID = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_RCProdD.RCD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId WHERE LEFT(dbo.DLK_T_RCProdD.RCD_ID,10) = '"& data("RC_ID") &"' ORDER BY Brg_nama ASC"

   set ddata = data_cmd.execute

   ' get barang keluar dari inventory
   data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_T_MaterialOutD.MO_Item FROM dbo.DLK_T_MaterialOutH RIGHT OUTER JOIN dbo.DLK_T_MaterialOutD ON dbo.DLK_T_MaterialOutH.MO_ID = dbo.DLK_T_MaterialOutD.MO_ID LEFT OUTER JOIN  dbo.DLK_M_Barang INNER JOIN  dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID INNER JOIN  dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId ON dbo.DLK_T_MaterialOutD.MO_Item = dbo.DLK_M_Barang.Brg_Id GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_T_MaterialOutH.MO_AktifYN, dbo.DLK_T_MaterialOutH.MO_PDDID, dbo.DLK_T_MaterialOutD.MO_Item HAVING (dbo.DLK_T_MaterialOutH.MO_AktifYN = 'Y') AND (dbo.DLK_T_MaterialOutH.MO_PDDID = '"& data("RC_PDDID") &"')"

   set getbarang = data_cmd.execute

   ' get jenis satuan
    data_cmd.commandText = "SELECT Sat_ID,Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

    set psatuan = data_cmd.execute

    call header("Detail Transaksi")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12  mt-3 text-center">
         <h3>DETAIL TRANSAKSI PENERIMAAN BARANG PRODUKSI</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center mb-3 labelId">
         <h3><%= left(id,2) &"-"& mid(id,3,4) &"-"& right(id,4) %></h3>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-4 mb-3 ">
         <label>Tanggal :</label>
         <input name="tgl" id="tgl" type="text" class="form-control" value="<%= cdate(data("RC_Date")) %>" readonly>
      </div>
      <div class="col-sm-4 mb-3">
         <label>No Produksi :</label>
         <input name="pddid" id="pddid" type="text" class="form-control" value="<%= left(data("RC_PDDid"),2)&"-"&mid(data("RC_PDDid"),3,3) &"/"& mid(data("RC_PDDid"),6,4) &"/"& mid(data("RC_PDDid"),10,4) &"/"& right(data("RC_PDDid"),3)  %>" readonly>
      </div>
      <div class="col-sm-4 mb-3 ">
         <label>Update ID :</label>
         <input name="update" id="update" type="text" class="form-control" value="<%= data("username") %>" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-4 mb-3 ">
         <label>Man Power :</label>
         <input name="mp" id="mp" type="number" class="form-control" value="<%= data("RC_MP") %>" readonly>
      </div>
      <div class="col-sm-8 mb-3">
         <label>Keterangan :</label>
         <input name="keterangan" id="keterangan" type="text" class="form-control" value="<%= data("RC_keterangan") %>" maxlength="50" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12">
         <div class="d-flex mb-3">
            <div class="me-auto p-2">
               <button type="button" class="btn btn-primary btn-modelrc" data-bs-toggle="modal" data-bs-target="#modelrc">Tambah Rincian</button>
            </div>
            <div class="p-2">
               <a href="index.asp" class="btn btn-danger">Kembali</a>
            </div>
         </div>
      </div>
   </div>
   <!-- table bom -->
   <div class="row">
      <div class="col-sm-12 text-center">
         <h5>DAFTAR PENERIMAAN BARANG</h5>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 ">
         
         <table class="table table-hover">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">Tanggal</th>
                  <th scope="col">Kode</th>
                  <th scope="col">Item</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Satuan</th>
                  <th scope="col">Penerima</th>
                  <th scope="col" class="text-center">Aksi</th>
               </tr>
            </thead>
            <tbody>
               <% 
               do while not ddata.eof 
               %>
               <tr>
                  <th>
                     <%= Cdate(ddata("RCD_Date")) %>
                  </th>
                  <th>
                     <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                  </th>
                  <td>
                     <%= ddata("Brg_Nama") %>
                  </td>
                  <td>
                     <%= ddata("RCD_qtysatuan") %>
                  </td>
                  <td>
                     <%= ddata("Sat_nama") %>
                  </td>
                  <td>
                     <%= ddata("RCD_Received") %>
                  </td>
                  <td class="text-center">
                     <% if session("PP1C") = true then  %>
                     <div class="btn-group" role="group" aria-label="Basic example">
                     <a href="aktifd.asp?id=<%= ddata("RCD_ID") %>&p=rcd_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'hapus detail transaksi')">Delete</a>
                     <% end if %>
                  </td>
               </tr>
               <% 
               ddata.movenext
               loop
               %>
            </tbody>
         </table>
      </div>
   </div>
</div>  
<!-- Modal -->
<div class="modal fade" id="modelrc" tabindex="-1" aria-labelledby="modelrcLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header">
            <h5 class="modal-title" id="modelrcLabel">Rincian Barang B.O.M</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
      <form action="rcd_add.asp?id=<%= id %>" method="post">
         <input type="hidden" name="rcid" id="rcid" value="<%= id %>">
         <div class="modal-body">
         <!-- table barang -->
         <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
               <table class="table" style="font-size:12px;">
                  <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                     <tr>
                        <th scope="col">No</th>
                        <th scope="col">Kode</th>
                        <th scope="col">Item</th>
                        <th scope="col">Pilih</th>
                     </tr>
                  </thead>
                  <tbody  class="contentrc">
                  <% 
                     no = 0
                     do while not getbarang.eof 
                     no = no + 1
                     %>
                     <tr>
                        <th>
                           <%= no %>
                        </th>
                        <th>
                           <%= getbarang("KategoriNama") &"-"& getbarang("jenisNama") %>
                        </th>
                        <td>
                           <%= getbarang("Brg_Nama") %>
                        </td>
                        <td>
                           <input class="form-check-input" type="radio" value="<%= getbarang("MO_Item") %>" name="item" id="item" required>
                        </td>
                     </tr>
                     <% 
                     getbarang.movenext
                     loop
                     %>
                  </tbody>
               </table>
            </div>
         </div>
            <!-- end table -->
            <div class="row">
               <input type="hidden" id="harga" class="form-control" name="harga" required>
               <div class="col-sm-3">
                  <label for="tgl" class="col-form-label">Tanggal</label>
               </div>
               <div class="col-sm-4 mb-3">
                  <input type="text" id="tgl" class="form-control" name="tgl" value="<%= date %>" autocomplete="off" onfocus="(this.type='date')" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-3">
                  <label for="qtty" class="col-form-label">Quantity</label>
               </div>
               <div class="col-sm-4 mb-3">
                  <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-3">
                  <label for="satuan" class="col-form-label">Satuan Barang</label>
               </div>
               <div class="col-sm-4 mb-3">
                  <select class="form-select" aria-label="Default select example" name="satuan" id="satuan" required> 
                     <option value="">Pilih</option>
                     <% do while not psatuan.eof %>
                     <option value="<%= psatuan("sat_ID") %>"><%= psatuan("sat_nama") %></option>
                     <%  
                     psatuan.movenext
                     loop
                     %>
                  </select>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-3 mb-3">
                  <label for="penerima" class="col-form-label">Penerima</label>
               </div>
               <div class="col-sm-9">
                  <input type="text" id="penerima" name="penerima" autocomplete="off" class="form-control" required>
               </div>
            </div>

         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Save</button>
         </div>
      </form>
      </div>
   </div>
</div>

<% 
   if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
     call detailrc()
   end if
   call footer()
%>