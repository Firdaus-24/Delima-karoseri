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
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_WebLogin.username, DLK_M_Vendor.ven_nama FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_MaterialReceiptH.MR_UpdateID = DLK_M_Weblogin.userid LEFT OUTER JOIN DLK_M_vendor ON DLK_T_MaterialReceiptH.MR_Venid = DLK_M_Vendor.ven_ID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') AND (dbo.DLK_T_MaterialReceiptH.MR_ID = '"& id &"')"

   set data = data_cmd.execute

   ' detail barang
   data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialReceiptD2.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, DLK_M_Rak.Rak_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialReceiptD2.MR_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_MaterialReceiptD2.MR_RakID = DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE LEFT(dbo.DLK_T_MaterialReceiptD2.MR_ID,13) = '"& id &"'"
   set ddata = data_cmd.execute

   ' get data barang po
   data_cmd.commandTExt = "SELECT (dbo.DLK_T_OrPemD.OPD_QtySatuan - ISNULL((SELECT SUM([MR_Qtysatuan]) as qtymr  FROM DLK_T_MaterialReceiptD2 WHERE MR_OPDOPHID = DLK_T_OrPemD.OPD_OPHID group by MR_Item ),0)) as sisa , dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_OrPemD.OPD_OPHID, dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_T_OrPemD.OPD_JenisSat LEFT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_T_OrPemD.OPD_Item = dbo.DLK_M_Barang.Brg_Id WHERE (LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) = '"& data("MR_OPHID") &"') AND dbo.DLK_T_OrPemD.OPD_QtySatuan - ISNULL((SELECT SUM([MR_Qtysatuan]) as qtymr  FROM DLK_T_MaterialReceiptD2 WHERE MR_OPDOPHID = DLK_T_OrPemD.OPD_OPHID group by MR_Item ),0) > 0 ORDER BY Brg_nama"
   ' Response.Write data_cmd.commandTExt & "<br>"
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

   <form action="incomed_add.asp?id=<%=id%>" method="post" onsubmit="validasiForm(this,event,'UPDATE HEADER INCOMMING','info')">
   <input type="hidden" value="" name="mrid">
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
         <label for="ophidmr" class="col-form-label">No. Purchase</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="ophidmr" name="ophidmr" class="form-control" value="<%= left(data("MR_OPHID"),2) %>-<%= mid(data("MR_OPHID"),3,3)%>/<%= mid(data("MR_OPHID"),6,4) %>/<%= right(data("MR_OPHID"),4) %>" readonly>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="vendor" class="col-form-label">Vendor</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="vendor" name="vendor" class="form-control" value="<%= data("ven_nama") %>" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-2 mb-3">
         <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-10 mb-3">
         <input type="text" id="keterangan" name="keterangan" class="form-control" value="<%= data("MR_Keterangan") %>" autocomplete="off" maxlength="50">
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12">
         <div class="d-flex justify-content-spacebetween mb-3">
            <div class="me-auto">
               <button type="submit" class="btn btn-success">
                  Update header
               </button>
   </form>
               <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalIncomedadd">
                  Tambah Rincian
               </button>
            </div>
            <div>
               <a href="./" class="btn btn-danger">Kembali</a>
            </div>
         </div>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 text-center mb-3">
         <h5>DAFTAR DOCUMENT</h5>
      </div>
   </div>   
   <div class="row">
      <div class="col-sm-12 mb-3">
         <table class="table table-hover table-bordered">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">No</th>
                  <th scope="col">Diterima</th>
                  <th scope="col">Kategori</th>
                  <th scope="col">Jenis</th>
                  <th scope="col">Barang</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Satuan</th>
                  <th scope="col">Harga</th>
                  <th scope="col">Rak</th>
                  <th scope="col">Aksi</th>
               </tr>
            </thead>
            <tbody>
               <% 
               no1 = 0
               rakID = ""
               do while not ddata.eof 
               no1 = no1 + 1

               ' cek data rak yang sudah terdaftar
               rakID = ddata("MR_RakID")

               %>
               <tr>
                  <th scope="row"><%= no1 %></th>
                  <td><%= ddata("MR_AcpDate") %></td>
                  <td><%= ddata("kategoriNama") %></td>
                  <td><%=  ddata("jenisNama") %></td>
                  <td><%= ddata("Brg_Nama") %></td>
                  <td>
                     <input type="number" name="qty" id="qty<%= no1 & ddata("MR_OPDOPHID") %>" value="<%= ddata("MR_Qtysatuan") %>" class="form-control" style="width:5rem;padding:3px;border:none;background:none;">
                  </td>
                  <td >
                     <select class="form-select" aria-label="Default select example" name="satuanmr" id="satuanmr<%= no1 & ddata("MR_OPDOPHID") %>" style="border:none;background:none;padding:10;">
                        <option value="<%= ddata("sat_ID") %>">
                           <%=ddata("sat_nama")%>
                        </option>
                        <% do while not dsatuan.eof %>
                           <option value="<%= dsatuan("sat_id") %>"><%= dsatuan("sat_nama") %></option>
                        <% 
                        Response.flush
                        dsatuan.movenext
                        loop
                        dsatuan.movefirst
                        %>
                     </select>
                  </td>
                  <td><%= replace(formatCurrency(ddata("MR_Harga")),"$","") %></td>
                  <td>
                     <select class="form-select" aria-label="Default select example" name="rakIncome" id="rakIncome<%= no1 & ddata("MR_OPDOPHID") %>" style="border:none;background:none;">
                        <option value="<%= rakID %>">
                           <% if ddata("MR_RakID") = "" then%>
                              Pilih
                           <% else %>
                              <%= ddata("Rak_Nama") %>
                           <% end if %>
                        </option>
                        <% do while not drak.eof %>
                           <option value="<%= drak("rak_Id") %>"><%= drak("Rak_Nama") %></option>
                        <% 
                        Response.flush
                        drak.movenext
                        loop
                        drak.movefirst
                        %>
                     </select>
                  </td>
                  <td>
                     <button type="button" class="btn badge text-bg-warning"  onclick="updateData('<%= ddata("MR_ID") %>', '<%= ddata("MR_OPDOPHID") %>', '<%= ddata("MR_Qtysatuan") %>', '<%=no1%>', '<%=ddata("MR_Acpdate")%>')">Update</button>
                  </td>
               </tr>
               <% 
               response.flush
               ddata.movenext
               loop
               %>
            </tbody>
         </table>
      </div>
   </div>
</div>  


<!-- Modal -->
<div class="modal fade" id="modalIncomedadd" tabindex="-1" aria-labelledby="modalIncomedaddLabel" aria-hidden="true" >
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalIncomedaddLabel">Tambah Rincian Barang</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
         <form action="incomed_add.asp?id=<%=id%>" method="post" onsubmit="return validasiFormIncomming(this,event,'DETAIL INCOMMING', 'info')">
            <input type="hidden" value="<%=data("MR_ID")%>" name="mrid">
            <div class='row mb-3'>
               <div class="col-md-12 mb-3 overflow-auto tblincomed" style="height:20rem;font-size:12px">
                  <table class="table table-hover">
                     <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                           <th scope="col">No</th>
                           <th scope="col">Kategori</th>
                           <th scope="col">Jenis</th>
                           <th scope="col">Barang</th>
                           <th scope="col">Satuan</th>
                           <th scope="col">Sisa</th>
                           <th scope="col">Pilih</th>
                        </tr>
                     </thead>
                     <tbody>
                        <% 
                        a = 0
                        Do While not datafp.eof 
                        a = a + 1
                        %>
                           <tr>
                              <td><%=a%></td>
                              <td><%=datafp("KategoriNama") %></td>
                              <td><%=datafp("jenisnama") %></td>
                              <td><%=datafp("Brg_nama")%></td>
                              <td><%=datafp("sat_nama")%></td>
                              <td><%=datafp("sisa")%></td>
                              <td class="text-center">
                                 <div class="form-check">
                                    <input class="form-check-input" type="radio" name="opdophid" id="opdophid1" value="<%=datafp("OPD_OPHID")&","&datafp("OPD_Item")%>" onclick="return ckSisaQtyMr(<%=datafp("sisa")%>)" required>
                                 </div>
                              </td>
                           </tr>
                              
                        <%
                        response.flush
                        datafp.movenext
                        loop
                        %>
                     </tbody>
                  </table>
               </div>
            </div>
            <div class='row'>
               <div class='col-sm-3 mb-3 '>
                  <label for="acpdate" class="form-label">Tanggal diterima</label>
                  <input type="date" id="acpdate" class="form-control" name="acpdate" required>
               </div>
               <div class='col-sm-3 mb-3 '>
                  <label for="qtyincomed" class="form-label">Quantity</label>
                  <input type="number" id="qtyincomed" class="form-control" name="qtyincomed" required>
               </div>
               <div class='col-sm-3 mb-3 '>
                  <label for="satuan" class="form-label">Satuan</label>
                  <select class="form-select" name="satuan" required>
                     <option value="">Pilih</option>
                     <%do while not dsatuan.eof%>
                        <option value="<%=dsatuan("sat_ID")%>"><%=dsatuan("sat_Nama")%></option>
                     <%
                     response.flush
                     dsatuan.movenext
                     loop
                     %>
                  </select>
               </div>
               <div class='col-sm-3 mb-3 '>
                  <label for="rak" class="form-label">Rak</label>
                  <select class="form-select" name="rak" required>
                     <option value="">Pilih</option>
                     <%do while not drak.eof%>
                        <option value="<%=drak("Rak_ID")%>"><%=drak("Rak_Nama")%></option>
                     <%
                     response.flush
                     drak.movenext
                     loop
                     %>
                  </select>
               </div>
            </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Save</button>
        </form>
      </div>
    </div>
  </div>
</div>
<script>
   const updateData = (id,trans, qtylama, urutan, acpdate) => {
      
      let qty = $(`#qty${urutan}${trans}`).val()
      let rak = $(`#rakIncome${urutan}${trans}`).val()
      let satuanmr = $(`#satuanmr${urutan}${trans}`).val()
      
      $.post( "updateMRD2.asp", { id, trans, rak, qtylama, qty, acpdate, satuanmr }).done(function( data ) {
         if (data == "DONE") {
            swal({title: 'Data Berhasil Diubah',text: 'Update detail incomming',icon: 'success',button: 'OK',}).then(function() {window.location = 'incomed_add.asp?id='+ id})
            return false
         } else if (data == "SATUAN DAN RAK") {
            swal({title: 'Data Berhasil Diubah',text: `${data}`,icon: 'success',button: 'OK',}).then(function() {window.location = 'incomed_add.asp?id='+ id})
            return false
         } else {
            swal(`PERHATIAN !!! ${data}`)
            return false
         }
      });
   }
</script>
<% 
   if Request.ServerVariables("REQUEST_METHOD") = "POST" then
      if Request.Form("mrid") <> "" then
         call incomePo()
      else
         call updateheader()
      end if
   end if
   call footer()
%>