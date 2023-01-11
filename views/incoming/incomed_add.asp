<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_incomming.asp"-->   
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' header
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_WebLogin.username FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptH.MR_UpdateID = DLK_M_Weblogin.userid WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') AND (dbo.DLK_T_MaterialReceiptH.MR_ID = '"& id &"')"

   set data = data_cmd.execute
   ' detail1
   data_cmd.commandTExt = "SELECT DLK_T_MaterialReceiptD1.*, DLK_M_WebLogin.username FROM DLK_T_MaterialReceiptD1 LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptD1.MR_Updateid = DLK_M_Weblogin.userid WHERE MR_ID = '"& id &"'"
   set data1 = data_cmd.execute

   ' get nomor menerimaan/faktur dan nomor produksi
   ' if data("MR_Type") = 1 then
   '    strfp = "SELECT IPH_ID FROM DLK_T_InvPemH WHERE IPH_AktifYN = 'Y' AND NOT EXISTS (SELECT MR_Transaksi FROM DLK_T_MaterialReceiptD1 WHERE MR_Transaksi = IPH_ID)"
   ' else
   '    strfp = "SELET * FROM DLK_M_ProductH WHERE PDAktifYN = 'Y' ORDER BY PDID ASC "
   ' end if

   data_cmd.commandTExt = "SELECT IPH_ID FROM DLK_T_InvPemH WHERE IPH_AktifYN = 'Y' AND NOT EXISTS (SELECT MR_Transaksi FROM DLK_T_MaterialReceiptD1 WHERE MR_Transaksi = IPH_ID)"

   set datafp = data_cmd.execute

   ' set rak 
   data_cmd.commandText = "SELECT Rak_ID, Rak_Nama FROM DLK_M_Rak WHERE Rak_aktifYN = 'Y' AND LEFT(Rak_ID,3) = '"& data("AgenID") &"' ORDER BY Rak_nama"

   set drak = data_cmd.execute

   call header("Proses Incomming")
%>
<!--#include file="../../navbar.asp"--> 
<!--auto relog page 
<meta http-equiv="refresh" content="10" />
-->
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
            <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100"/>
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
         <label for="jenis" class="col-form-label">Update ID</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="jenis" name="jenis" class="form-control" value="<%= data("username") %>" readonly>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="type" class="col-form-label">Type</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="type" name="type" class="form-control"  <% if data("MR_Type") = 1 then %>value="Purchase" <% else %>value="Produksi" <% end if %> readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-2 mb-3">
         <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="keterangan" name="keterangan" class="form-control" value="<%= data("MR_Keterangan") %>" autocomplete="off" maxlength="50" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12">
         <div class="d-flex mb-3">
            <div class="me-auto p-2">
               <button type="button" class="btn btn-primary btn-modalIncomed" data-bs-toggle="modal" data-bs-target="#modalIncomed">Tambah Doc</button>
            </div>
            <div class="p-2">
               <a href="index.asp" class="btn btn-danger">Kembali</a>
            </div>
         </div>
      </div>
   </div>
   <% if not data1.eof then %>
   <div class="row">
      <div class="col-sm-12 text-center mb-3">
         <h5>DAFTAR DOCUMENT</h5>
      </div>
   </div>   
   <div class="row">
      <div class="col-sm-12 mb-3">
         <table class="table table-striped">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">No</th>
                  <th scope="col">Kode Item</th>
                  <th scope="col">Item</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Satuan</th>
                  <th scope="col">Harga</th>
                  <th scope="col">Rak</th>
                  <th scope="col">Aksi</th>
               </tr>
            </thead>
            <tbody>
               <% 
               do while not data1.eof 
               %>
               <tr>
                  <td>Document</td>
                  <td><%= data1("MR_Transaksi") %></td>
                  <td><%= data1("MR_Updatetime") %></td>
                  <td colspan="5"><%= data1("username") %></td>
               </tr>
               <% 
               no1 = 0
               rakID = ""
               data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptD2.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, DLK_M_Rak.Rak_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialReceiptD2.MR_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_MaterialReceiptD2.MR_RakID = DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE dbo.DLK_T_MaterialReceiptD2.MR_ID = '"& id &"' AND LEFT(MR_Transaksi,13) = '"& data1("MR_Transaksi") &"'"
               set data2 = data_cmd.execute

               do while not data2.eof 
               no1 = no1 + 1

               ' cek data rak yang sudah terdaftar
               rakID = data2("MR_RakID")

               %>
               <tr>
                  <th scope="row"><%= no1 %></th>
                  <td><%= data2("kategoriNama") &"-"& data2("jenisNama") %></td>
                  <td><%= data2("Brg_Nama") %></td>
                  <td>
                     <input type="number" name="qty" id="qty<%= data2("MR_Transaksi") %>" value="<%= data2("MR_Qtysatuan") %>" class="form-control" style="width:5rem;padding:3px;border:none;background:none;">
                  </td>
                  <td><%= data2("Sat_nama") %></td>
                  <td><%= replace(formatCurrency(data2("MR_Harga")),"$","") %></td>
                  <td>
                     <select class="form-select" aria-label="Default select example" name="rakIncome" id="rakIncome<%= data2("MR_Transaksi") %>" style="border:none;background:none;margin:inherit;padding:6px;">
                        <option value="<%= rakID %>">
                           <% if data2("MR_RakID") = "" then%>
                              Pilih
                           <% else %>
                              <%= data2("Rak_Nama") %>
                           <% end if %>
                        </option>
                        <% do while not drak.eof %>
                           <option value="<%= drak("rak_Id") %>"><%= drak("Rak_Nama") %></option>
                        <% 
                        drak.movenext
                        loop
                        drak.movefirst
                        %>
                     </select>
                  </td>
                  <td>
                     <button type="button" class="btn badge text-bg-warning"  onclick="updateData('<%= data2("MR_ID") %>', '<%= data2("MR_transaksi") %>')">Update</button>
                  </td>
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
   <% end if %>
</div>  
<!-- Modal -->
<div class="modal fade" id="modalIncomed" tabindex="-1" aria-labelledby="modalIncomedLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header">
            <h1 class="modal-title fs-5" id="modalIncomedLabel">Tambah Dokumen Penerimaan Barang</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <form action="incomed_add.asp?id=<%= id %>" method="post">
            <input type="hidden" name="id" value="<%= id %>">
            <div class="modal-body">
               <div class="row">
                  <div class="col-sm-2">
                     <label for="faktur">Nomor</label>
                  </div>
                  <div class="col-sm">
                     <select class="form-select" aria-label="Default select example" name="fakturH" id="fakturH" required>
                        <option value="">Pilih</option>
                        <% do while not datafp.eof %>
                        <option value="<%= datafp("IPH_ID") %>"><%= left(datafp("IPH_ID"),2) %>-<% call getAgen(mid(datafp("IPH_ID"),3,3),"") %>/<%= mid(datafp("IPH_ID"),6,4) %>/<%= right(datafp("IPH_ID"),4) %></option>
                        <% 
                        datafp.movenext
                        loop
                        %>
                     </select>
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

<script>
const updateData = (id,trans) => {
   let qty = $(`#qty${trans}`).val()
   let rak = $(`#rakIncome${trans}`).val()
   
   $.post( "updateMRD2.asp", { id, trans, rak, qty }).done(function( data ) {
      if(data == "ERROR"){
         swal("Data tidak Valid")
      }else{
         swal({title: 'Data Berhasil Diubah',text: 'Update Rak & Quantity',icon: 'success',button: 'OK',}).then(function() {window.location = 'incomed_add.asp?id='+ id})
      }
   });
}
</script>
<% 
   if Request.ServerVariables("REQUEST_METHOD") = "POST" then
      call tambahIncome()
   end if
   call footer()
%>