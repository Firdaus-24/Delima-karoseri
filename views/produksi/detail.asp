<!--#include file="../../init.asp"-->
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' header
   data_cmd.commandTExt = "SELECT DLK_T_ProduksiH.*, GLB_M_Agen.AgenName FROM DLK_T_ProduksiH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProduksiH.PDH_AgenID = GLB_M_Agen.AgenID WHERE PDH_ID = '"& id &"'"

   set data = data_cmd.execute  

   ' get detail produksi
   data_cmd.commandTExt = "SELECT DLK_T_ProduksiD.*,  dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Barang.Brg_Nama FROM DLK_M_Barang RIGHT OUTER JOIN  DLK_T_ProduksiD ON DLK_T_ProduksiD.PDD_Item = DLK_M_Barang.Brg_ID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE LEFT(PDD_ID,13) = '"& data("PDH_ID") &"' ORDER BY PDD_ID ASC"
   ' response.write data_cmd.commandText & "<br>"
   set ddata = data_cmd.execute 


   call header("Detail Produksi")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
   <div class="row">
      <div class="col-lg-12 mt-3 text-center">
         <h3>DETAIL PRODUKSI</h3>
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
         <% if session("ENG1D") = true then %>
         <button type="button" class="btn btn-secondary" onclick="window.location.href='export-Xlsproduksi.asp?id=<%= data("PDH_ID") %>'">Export</button>
         <% end if %>
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
                  <th scope="col">No. Drawing</th>
                  <th scope="col">Kode</th>
                  <th scope="col">Item</th>
                  <th scope="col">Type</th>
                  <th scope="col">Brand</th>
                  <th scope="col">PPIC</th>
                  <th scope="col" class="text-center">Aksi</th>
               </tr>
            </thead>
            <tbody>
               <% 
               do while not ddata.eof 

               ' cek nomor drawing
               data_cmd.commandTExt = "SELECT ISNULL(dbo.DLK_M_Sasis.SasisType, '') AS type, ISNULL(dbo.DLK_M_Brand.BrandName, '') AS brand, ISNULL(dbo.DLK_M_Sasis.SasisDrawing, '') AS drawing FROM dbo.DLK_M_Brand INNER JOIN dbo.DLK_M_Sasis ON dbo.DLK_M_Brand.BrandID = dbo.DLK_M_Sasis.SasisBrandID RIGHT OUTER JOIN dbo.DLK_M_BOMH ON dbo.DLK_M_Sasis.SasisID = dbo.DLK_M_BOMH.BMSasisID WHERE (dbo.DLK_M_BOMH.BMAktifYN = 'Y') AND (dbo.DLK_M_BOMH.BMID = '"& ddata("PDD_BMID") &"') "
               set getsasis = data_cmd.execute
               %>
                  <tr>
                     <th>
                        <%= left(ddata("PDD_id"),2) %>-<%= mid(ddata("PDD_id"),3,3) %>/<%= mid(ddata("PDD_id"),6,4) %>/<%= mid(ddata("PDD_id"),10,4) %>/<%= right(ddata("PDD_id"),3)  %>
                     </th>
                     <td>
                        <%= left(ddata("PDD_BMID"),2) %>-<%= mid(ddata("PDD_BMID"),3,3) %>/<%= mid(ddata("PDD_BMID"),6,4) %>/<%= right(ddata("PDD_BMID"),3)  %>
                     </td>
                     <td>
                        <% if getsasis("drawing") <> "" then  %>
                        <a href="../sasis/openpdf.asp?id=<%= getsasis("drawing") %>&p=draw" style="text-decoration:none;">
                        <%= LEft(getsasis("drawing"),5) &"-"& mid(getsasis("drawing"),6,4) &"-"& right(getsasis("drawing"),3)  %>
                        </a>
                        <% end if %>
                     </td>
                     <td>
                        <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                     </td>
                     <td>
                        <%= ddata("brg_nama")%>
                     </td>
                     <td>
                        <%= getsasis("type")%>
                     </td>
                     <td>
                        <%= getsasis("Brand")%>
                     </td>
                     <td>
                        <%= ddata("PDD_PICName")%>
                     </td>
                     <td class="text-center">
                        <div class="btn-group btn-group-sm" role="group">
                           <button type="button" class="btn btn-outline-dark" onclick="window.location.href='export-Dproduksi.asp?id=<%= ddata("PDD_ID") %>'">Cetak</button>
                        </div>
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
<% 
   call footer()
%>