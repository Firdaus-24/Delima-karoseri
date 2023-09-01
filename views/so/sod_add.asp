<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_orjul.asp"-->
<% 
   if session("MK1A") = false then
      Response.Redirect("./")
   end if

   id = trim(Request.QueryString("id"))
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandTExt = "SELECT dbo.MKT_T_OrJulH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.MKT_T_OrJulH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_OrJulH.OJH_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_OrJulH.OJH_CustID = dbo.DLK_M_Customer.custId WHERE (MKT_T_OrJulH.OJH_AktifYN = 'Y') AND (MKT_T_OrJulH.OJH_ID = '"& id &"')"

   set data = data_cmd.execute

   data_cmd.commandText = "SELECT dbo.MKT_T_OrJulD.OJD_OJHID, dbo.MKT_T_OrJulD.OJD_Item, dbo.MKT_T_OrJulD.OJD_Qtysatuan, dbo.MKT_T_OrJulD.OJD_JenisSat, dbo.MKT_T_OrJulD.OJD_Harga, dbo.MKT_T_OrJulD.OJD_Diskon, dbo.MKT_T_OrJulD.OJD_Keterangan, dbo.MKT_T_OrJulD.OJD_Updatetime, dbo.MKT_T_OrJulD.OJD_UpdateID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_WebLogin.username FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.MKT_T_OrJulD ON dbo.DLK_M_Barang.Brg_Id = dbo.MKT_T_OrJulD.OJD_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_OrJulD.OJD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_WebLogin ON MKT_T_OrjulD.OJD_Updateid = DLK_M_webLogin.userid WHERE LEFT(dbo.MKT_T_OrJulD.OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY dbo.MKT_T_OrjulD.OJD_OJHID" ' response.write data_cmd.commandText & "<br>"
   set ddata = data_cmd.execute

   ' get nomor BOM
   data_cmd.commandText = "SELECT dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_BOMH.BMID, dbo.DLK_M_BOMH.BMBrgID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.DLK_M_BOMH ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_BOMH.BMBrgID WHERE (dbo.DLK_M_BOMH.BMApproveYN = 'Y') AND (dbo.DLK_M_BOMH.BMAgenID = '"& data("OJH_AgenID") &"') AND (dbo.DLK_M_BOMH.BMAktifYN = 'Y') ORDER BY BMID, Brg_Nama"
   ' response.write data_cmd.commandText & "<br>"
   set databom = data_cmd.execute

   ' set satuan
   data_cmd.commandTExt = "SELECT Sat_ID, Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama"

   set datasatuan = data_cmd.execute

call header("Tambah SalesOrder") %>
   <!--#include file="../../navbar.asp"-->
   <div class="container">
      <div class="row">
         <div class="col-lg-12 mt-3 text-center">
            <h3>FORM TAMBAH SALES ORDER PROJECT</h3>
         </div>
      </div>
      <div class="row">
         <div class="col-lg-12 mb-3 text-center labelId">
            <h3>
               <%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)  %>
            </h3>
         </div>
      </div>
      <div class="row align-items-center">
         <div class="col-lg-2 mb-3">
            <label for="agen" class="col-form-label">Cabang / Agen</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="text" id="agen" name="agen" value="<%= data("agenName") %>" class="form-control" readonly>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="tgl" class="col-form-label">Tanggal</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="text" id="tgl" name="tgl" value="<%= cdate(data("OJH_Date")) %>" class="form-control" readonly>
         </div>
      </div>
      <div class="row align-items-center">
         <div class="col-lg-2 mb-3">
            <label for="customer" class="col-form-label">Customer</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="text" id="agen" name="agen" value="<%= data("custnama") %>" class="form-control" readonly>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="text" id="tgljt" name="tgljt" class="form-control" <% if Cdate(data("OJH_JTDate")) <> Cdate("1/1/1900") then%> value="<%= cdate(data("OJH_JTDate")) %>" <% end if %> readonly>
         </div>
      </div>
      <div class="row align-items-center">
         <div class="col-lg-2 mb-3">
            <label for="diskon" class="col-form-label">Diskon All</label>
         </div>
         <div class="col-lg-4 mb-3">
            <div class="input-group ">
               <input type="number" id="diskon" name="diskon" value="<%= data("OJH_DiskonAll") %>"  class="form-control" readonly>
               <span class="input-group-text" >%</span>
            </div>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="ppn" class="col-form-label">PPn</label>
         </div>
         <div class="col-lg-4 mb-3">
            <div class="input-group">
               <input type="number" id="ppn" name="ppn" class="form-control"  value="<%= data("OJH_ppn") %>" readonly>
               <span class="input-group-text" >%</span>
            </div>
         </div>
      </div>
      <div class="row">
         <div class="col-lg-2 mb-3">
            <label for="timeWork" class="col-form-label">Lama Pengerjaan</label>
         </div>
         <div class="col-lg-4 mb-3">
            <div class="input-group">
               <input type="number" id="timeWork" name="timeWork" class="form-control"  value="<%= data("OJH_timeWork") %>" readonly>
               <span class="input-group-text">/ Hari</span>
            </div>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="keterangan" class="col-form-label">Keterangan</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off"  value="<%= data("OJH_Keterangan") %>" readonly>
         </div>
      </div>
      <div class="row">
         <div class="col-lg-12 mb-3 text-center d-flex justify-content-between">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalDetailso">Tambah Rincian</button>
            <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
         </div>
      </div>
      <div class="row">
         <div class="col-lg-12">
            <table class="table table-hover table-bordered">
               <thead class="bg-secondary text-light ">
                  <tr>
                     <th scope="col">No</th>
                     <th scope="col">Kategori</th>
                     <th scope="col">Jenis</th>
                     <th scope="col">Model</th>
                     <th scope="col">Quantity</th>
                     <th scope="col">Satuan</th>
                     <th scope="col">Harga</th>
                     <th scope="col">Diskon</th>
                     <th scope="col">Keterangan</th>
                     <th scope="col" class="text-center">Aksi</th>
                  </tr>
               </thead>
               <tbody>
                  <% 
                  no = 0
                  do while not ddata.eof 
                  no = no + 1
                  %>
                     <tr>
                        <th>
                           <%= no  %>
                        </th>
                        <td>
                           <%=ddata("KategoriNama") %>
                        </td>
                        <td>
                           <%= ddata("jenisNama") %>
                        </td>
                        <td>
                           <%= ddata("Brg_Nama") %>
                        </td>
                        <td>
                           <%= ddata("OJD_Qtysatuan")%>
                        </td>
                        <td>
                           <%= ddata("sat_Nama")%>
                        </td>
                        <td>
                           <%= replace(formatCurrency(ddata("OJD_Harga")),"$","")%>
                        </td>
                        <td>
                           <%= ddata("OJD_Diskon")%>
                        </td>
                        <td>
                           <%= ddata("OJD_Keterangan")%>
                        </td>
                        <td class="text-center">
                           <%if session("MK1C") = true then%>
                              <a href="aktifd.asp?id=<%= ddata("OJD_OJHID") %>&p=sod_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Nomor Sales Order')">Delete</a>
                           <%else%>
                              -
                           <%end if%>
                        </td>
                     </tr>
                  <% 
                  Response.flush
                  ddata.movenext
                  loop
                  %>
               </tbody>
            </table>
         </div>
      </div>   
   </div>  
<!-- Modal -->
<div class="modal fade" id="modalDetailso" tabindex="-1" aria-labelledby="modalDetailsoLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <h1 class="modal-title fs-5" id="modalDetailsoLabel">Rincian Detail</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body">
            <form action="sod_add.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Tambah Detail Sales Order','warning')">
            <input type="hidden" value="<%= id %>" name="id">
            <div class="row">
               <div class="col-sm-12 mb-4 overflow-auto" style="height:15rem;font-size:14px;">
               <table class="table table-hover" >
                  <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                     <tr>
                        <th scope="col">No B.O.M</th>
                        <th scope="col">kode</th>
                        <th scope="col">Item</th>
                        <th scope="col">Pilih</th>
                     </tr>
                  </thead>
                  <tbody>
                     <% 
                     do while not databom.eof 
                     %>
                     <tr>
                        <td><%= left(databom("BMID"),2) %>/<%= mid(databom("BMID"),3,3) %>/<%= mid(databom("BMID"),6,4) %>/<%= right(databom("BMID"),3)  %> </td>
                        <td><%= databom("KategoriNama") &" - "& databom("jenisNama") %></td>
                        <td><%= databom("brg_Nama") %></td>
                        <td>
                           <input class="form-check-input" type="radio" name="itemSo" id="itemSo" value="<%= databom("BMBrgID") %>" required>
                        </td>
                     </tr>
                     <% 
                     response.flush
                     databom.movenext
                     loop
                     %>
                  </tbody>
               </table>
               </div>
            </div>
            <hr>
            <div class="row">
               <div class="col-sm-3 mb-3">
                  <label class="form-check-label" for="qty">
                     Quantity
                  </label>
               </div>
               <div class="col-sm-6 mb-3">
                  <input type="number" name="qty" id="qty" class="form-control" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-3 mb-3">
                  <label class="form-check-label" for="picname">
                     Satuan
                  </label>
               </div>
               <div class="col-sm-6 mb-3">
                  <select class="form-select" aria-label="Default select example" name="satuan" name="satuan" required>
                     <option value="">Pilih</option>
                     <% Do While not datasatuan.eof%>
                     <option value="<%= datasatuan("Sat_ID") %>"><%= datasatuan("Sat_Nama") %></option>
                     <% 
                     datasatuan.movenext
                     loop
                      %>   
                  </select>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-3 mb-3">
                  <label class="form-check-label" for="harga">
                     Harga
                  </label>
               </div>
               <div class="col-sm-6 mb-3">
                  <input type="text" name="harga" id="hargaSoNew" class="form-control" onchange="settingFormatRupiah(this.value, 'hargaSoNew')" inputmode="Numeric" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-3 mb-3">
                  <label class="form-check-label" for="diskon">
                     Diskon
                  </label>
               </div>
               <div class="col-sm-6 mb-3">
                  <input type="number" name="diskon" id="diskon" class="form-control">
               </div>
            </div>
            <div class="row">
               <div class="col-sm-3 mb-3">
                  <label class="form-check-label" for="keterangan">
                     Keterangan
                  </label>
               </div>
               <div class="col-sm-9 mb-3">
                  <div class="form-floating">
                     <textarea class="form-control" name="keterangan" id="keterangan" maxlength="100" style="height: 100px"></textarea>
                     <label for="keterangan">Keterangan</label>
                  </div>
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
<% if request.ServerVariables("REQUEST_METHOD")="POST" then
      call tambahOrjulD() 
   end if 
      
call footer() %>