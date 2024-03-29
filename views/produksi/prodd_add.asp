<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_produksi.asp"-->
<!--#include file="../../functions/func_DateDiffWeekDays.asp"-->  
<% 
   if session("ENG1A") = false then
      Response.Redirect("index.asp")
   end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' header
   data_cmd.commandTExt = "SELECT DLK_T_ProduksiH.*, GLB_M_Agen.AgenName FROM DLK_T_ProduksiH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProduksiH.PDH_AgenID = GLB_M_Agen.AgenID WHERE PDH_ID = '"& id &"' AND PDH_AktifYN = 'Y'"

   set data = data_cmd.execute  

   ' get detail produksi
   data_cmd.commandTExt = "SELECT DLK_T_ProduksiD.*,  dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Barang.Brg_Nama FROM DLK_M_Barang RIGHT OUTER JOIN  DLK_T_ProduksiD ON DLK_T_ProduksiD.PDD_Item = DLK_M_Barang.Brg_ID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE LEFT(PDD_ID,13) = '"& data("PDH_ID") &"' ORDER BY PDD_ID ASC"
   ' response.write data_cmd.commandText & "<br>"
   set ddata = data_cmd.execute 

   ' get nomor BOM
   data_cmd.commandTExt = "SELECT dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_BOMH.BMID, dbo.DLK_M_BOMH.BMBrgID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.DLK_M_BOMH ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_BOMH.BMBrgID WHERE (dbo.DLK_M_BOMH.BMApproveYN = 'Y') AND (dbo.DLK_M_BOMH.BMAgenID = '"& data("PDH_AgenID") &"') AND (dbo.DLK_M_BOMH.BMAktifYN = 'Y') ORDER BY BMID, Brg_Nama"
   ' response.write data_cmd.commandText & "<br>"
   set databom = data_cmd.execute

   call header("Form Detail Produksi")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
   <div class="row">
      <div class="col-lg-12 mt-3 text-center">
         <h3>FORM DETAIL PRODUKSI</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center labelId">
         <h3><%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)  %></h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 mb-3 text-center">
         <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100" />
      </div>
   </div>
   <div class="row">
      <div class="col-lg-2 mb-3">
         <label for="agen" class="col-form-label">Cabang / Agen</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="agen" name="agen" class="form-control" value="<%=data("agenName") %>" readonly>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("PDH_Date")) %>" readonly>
      </div>
   </div>
   <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
         <label for="prototype" class="col-form-label">Prototype</label>
      </div>
      <div class="col-sm-4 mb-3">
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="prototype" id="prototypeY" <% if data("PDH_PrototypeYN") = "Y" then %>checked <% end if %> disabled>
            <label class="form-check-label" for="prototypeY">Yes</label>
         </div>
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="prototype" id="prototypeN"  <% if data("PDH_PrototypeYN") = "N" then %>checked <% end if %> disabled>
            <label class="form-check-label" for="prototypeN">No</label>
         </div>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="model" class="col-form-label">Model</label>
      </div>
      <div class="col-sm-4 mb-3">
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="model" id="modelL" value="L" <% if data("PDH_Model") = "L" then %>checked <% end if %> disabled>
            <label class="form-check-label" for="modelL">Leguler</label>
         </div>
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="model" id="modelP" value="P" <% if data("PDH_Model") = "P" then %>checked <% end if %> disabled>
            <label class="form-check-label" for="modelP" >Project</label>
         </div>
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="model" id="modelS" value="S" <% if data("PDH_Model") = "S" then %>checked <% end if %> disabled>
            <label class="form-check-label" for="modelS">Sub Part</label>
         </div>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-2 mb-3">
         <label for="tgla" class="col-form-label">Start Date</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="tgla" name="tgla" class="form-control" value="<%= Cdate(data("PDH_startDate")) %>" readonly>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="tgle" class="col-form-label">End Date</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="tgle" name="tgle" class="form-control" value="<%= Cdate(data("PDH_EndDate")) %>" readonly>
      </div>
   </div>      
   <div class="row">
      <div class="col-lg-2 mb-3">
         <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-10 mb-3">
         <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off" value="<%= data("PDH_Keterangan") %>" readonly>
      </div>
   </div>  
   <div class="row">
      <div class="col-lg-12 mb-3 text-center d-flex justify-content-between">
         <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalDetailProduksi">Tambah Rincian</button>
         <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
      </div>
   </div>

   <div class="row">
      <div class="col-lg-12">
         <table class="table table-hover">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">ID</th>
                  <th scope="col">B.O.M ID</th>
                  <th scope="col">Kode</th>
                  <th scope="col">Item</th>
                  <th scope="col">PPIC</th>
                  <th scope="col" class="text-center">Aksi</th>
               </tr>
            </thead>
            <tbody>
               <% 
               do while not ddata.eof 
               %>
                  <tr>
                     <th>
                        <%= left(ddata("PDD_id"),2) %>-<%= mid(ddata("PDD_id"),3,3) %>/<%= mid(ddata("PDD_id"),6,4) %>/<%= mid(ddata("PDD_id"),10,4) %>/<%= right(ddata("PDD_id"),3)  %>
                     </th>
                     <td>
                        <a href="<%=url%>views/bom/detailBom.asp?id=<%= ddata("PDD_BMID") %>" style="cursor:pointer;text-decoration:none;color:black;" target="blank">
                           <%= left(ddata("PDD_BMID"),2) %>-<%= mid(ddata("PDD_BMID"),3,3) %>/<%= mid(ddata("PDD_BMID"),6,4) %>/<%= right(ddata("PDD_BMID"),3)  %>
                        </a>
                     </td>
                     <td>
                        <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                     </td>
                     <td>
                        <%= ddata("brg_nama")%>
                     </td>
                     <td>
                        <%= ddata("PDD_PicName")%>
                     </td>
                     <td class="text-center">
                        <div class="btn-group" role="group" aria-label="Basic example">
                        <a href="aktifd.asp?id=<%= ddata("PDD_ID") %>&p=prodd_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Nomor Produksi')">Delete</a>
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
<div class="modal fade" id="modalDetailProduksi" tabindex="-1" aria-labelledby="modalDetailProduksiLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <h1 class="modal-title fs-5" id="modalDetailProduksiLabel">Rincian Detail Produksi</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body">
            <form action="prodd_add.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Tambah Detail Nomor Produksi','warning')">
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
                           <input class="form-check-input" type="radio" name="bomid" id="bomid" value="<%= databom("BMID")&","& databom("BMBrgID") %>" required>
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
               <div class="col-sm-2 mb-3">
                  <label class="form-check-label" for="capacity">
                     Capacity
                  </label>
               </div>
               <div class="col-sm-4 mb-3">
                  <input type="number" name="capacity" id="capacity" class="form-control" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-2 mb-3">
                  <label class="form-check-label" for="picname">
                     picname
                  </label>
               </div>
               <div class="col-sm-10 mb-3">
                  <input type="text" name="picname" id="picname" class="form-control" maxlength="100" autocomplete="off" required>
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

<% 
   if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
      call tambahProduksiD()
   end if
   call footer()
%>