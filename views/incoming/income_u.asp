<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_incomming.asp"-->   
<% 
   if session("INV2A") = false then
      Response.Redirect("./")
   end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' header
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_WebLogin.username FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptH.MR_UpdateID = DLK_M_Weblogin.userid WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') AND (dbo.DLK_T_MaterialReceiptH.MR_ID = '"& id &"')"

   set data = data_cmd.execute
   ' detail1
   data_cmd.commandTExt = "SELECT DLK_T_MaterialReceiptD1.*, DLK_M_WebLogin.username FROM DLK_T_MaterialReceiptD1 LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptD1.MR_Updateid = DLK_M_Weblogin.userid WHERE MR_ID = '"& id &"'"
   set data1 = data_cmd.execute

   ' get data po
   data_cmd.commandTExt = "SELECT dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_M_Vendor.Ven_Nama, SUM(ISNULL(dbo.DLK_T_OrPemD.OPD_QtySatuan, 0)) AS qtypo FROM dbo.DLK_M_Vendor RIGHT OUTER JOIN dbo.DLK_T_OrPemH ON dbo.DLK_M_Vendor.Ven_ID = dbo.DLK_T_OrPemH.OPH_venID RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y') AND (dbo.DLK_T_OrPemH.OPH_KID = 1) GROUP BY dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_M_Vendor.Ven_Nama HAVING SUM(ISNULL(dbo.DLK_T_OrPemD.OPD_QtySatuan, 0)) - ISNULL((SELECT SUM(ISNULL(dbo.DLK_T_MaterialReceiptD2.MR_Qtysatuan, 0)) AS qtymr FROM dbo.DLK_T_MaterialReceiptD1 RIGHT OUTER JOIN dbo.DLK_T_MaterialReceiptD2 ON dbo.DLK_T_MaterialReceiptD1.MR_Transaksi = LEFT(dbo.DLK_T_MaterialReceiptD2.MR_Transaksi, 13) WHERE (dbo.DLK_T_MaterialReceiptD1.MR_Transaksi = dbo.DLK_T_OrPemH.OPH_ID) GROUP BY dbo.DLK_T_MaterialReceiptD1.MR_Transaksi),0) > 0 AND SUM(ISNULL(dbo.DLK_T_OrPemD.OPD_QtySatuan, 0)) - ISNULL((SELECT SUM(ISNULL(dbo.DLK_T_MaterialReceiptD2.MR_Qtysatuan, 0)) AS qtymr FROM dbo.DLK_T_MaterialReceiptD1 RIGHT OUTER JOIN dbo.DLK_T_MaterialReceiptD2 ON dbo.DLK_T_MaterialReceiptD1.MR_Transaksi = LEFT(dbo.DLK_T_MaterialReceiptD2.MR_Transaksi, 13) WHERE (dbo.DLK_T_MaterialReceiptD1.MR_Transaksi = dbo.DLK_T_OrPemH.OPH_ID) GROUP BY dbo.DLK_T_MaterialReceiptD1.MR_Transaksi ),0) <> 0 ORDER BY dbo.DLK_T_OrPemH.OPH_ID"

   set datafp = data_cmd.execute

   ' set rak 
   data_cmd.commandText = "SELECT Rak_ID, Rak_Nama FROM DLK_M_Rak WHERE Rak_aktifYN = 'Y' AND LEFT(Rak_ID,3) = '"& data("AgenID") &"' ORDER BY Rak_nama"

   set drak = data_cmd.execute

   ' set satuan 
   data_cmd.commandText = "SELECT sat_ID, sat_Nama FROM DLK_M_satuanbarang WHERE sat_aktifYN = 'Y' ORDER BY sat_nama"

   set dsatuan = data_cmd.execute

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
            <h3><%= LEFT(data("MR_ID"),2) &"-"& mid(data("MR_ID"),3,3) &"/"& mid(data("MR_ID"),6,4) &"/"& right(data("MR_ID"),4)%></h3>
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
         <div class="d-flex justify-content-spacebetween mb-3">
            <div>
               <a href="./" class="btn btn-danger">Kembali</a>
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
                  <th scope="col">Diterima</th>
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
                  <td colspan="2">Document :</td>
                  <td><%= LEFT(data1("MR_Transaksi"),2) &"-"& mid(data1("MR_Transaksi"),3,3) &"/"& mid(data1("MR_Transaksi"),6,4) &"/"& right(data1("MR_Transaksi"),4)%></td>
                  <td>User :</td>
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
                  <td><%= data2("MR_AcpDate") %></td>
                  <td><%= data2("kategoriNama") &"-"& data2("jenisNama") %></td>
                  <td><%= data2("Brg_Nama") %></td>
                  <td>
                     <input type="number" name="qty" id="qty<%= no1 & data2("MR_Transaksi") %>" value="<%= data2("MR_Qtysatuan") %>" class="form-control" style="width:5rem;padding:3px;border:none;background:none;">
                  </td>
                  <td><%= data2("Sat_nama") %></td>
                  <td><%= replace(formatCurrency(data2("MR_Harga")),"$","") %></td>
                  <td>
                     <select class="form-select" aria-label="Default select example" name="rakIncome" id="rakIncome<%= no1 & data2("MR_Transaksi") %>" style="border:none;background:none;margin:inherit;padding:6px;">
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
                     <button type="button" class="btn badge text-bg-warning"  onclick="updateData('<%= data2("MR_ID") %>', '<%= data2("MR_transaksi") %>', '<%= data2("MR_Qtysatuan") %>', '<%=no1%>', '<%=data2("MR_Acpdate")%>')">Update</button>
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
<script>
const updateData = (id,trans, qtylama, urutan, acpdate) => {
   let qty = $(`#qty${urutan}${trans}`).val()
   let rak = $(`#rakIncome${urutan}${trans}`).val()

   $.post( "updateMRD2.asp", { id, trans, rak, qtylama, qty, acpdate }).done(function( data ) {
      if(data != "DONE"){
         swal({title: `PERHATIAN !!! `,text: `${data}`,icon: 'success',button: 'OK',}).then(function() {window.location = 'income_u.asp?id='+ id})
         return false
      }else{
         swal({title: 'Data Berhasil Diubah',text: 'Update Rak & Quantity',icon: 'success',button: 'OK',}).then(function() {window.location = 'income_u.asp?id='+ id})
      }
   });
}
</script>
<% 
   call footer()
%>