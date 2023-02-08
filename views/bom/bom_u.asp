<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_bom.asp"--> 
<% 
   if session("ENG2B") = false then
      Response.Redirect("index.asp")
   end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' get data header
   data_cmd.commandText = "SELECT dbo.DLK_M_BOMH.*, dbo.DLK_M_Barang.Brg_Nama, GLB_M_Agen.AgenName FROM dbo.DLK_M_BOMH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMH.BMBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_M_BOMH.BMAgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_M_BOMH.BMID = '"& id &"' AND dbo.DLK_M_BOMH.BMAktifYN = 'Y'"

   set data = data_cmd.execute

   ' get data detail
   data_cmd.commandText = "SELECT dbo.DLK_M_BOMD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_M_BOMD.BMDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMD.BMDItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.jenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_M_BOMD.BMDBMID,12) = '"& data("BMID") &"' ORDER BY BMDBMID ASC"

   set ddata = data_cmd.execute

   ' getbarang 
   data_cmd.commandText = "SELECT DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE Brg_AktifYN = 'Y' AND Brg_ID <> '"& data("BMBrgID") &"' AND LEFT(Brg_ID,3) = '"& data("BMAgenID") &"' ORDER BY Brg_Nama ASC"

   set barang = data_cmd.execute

   ' get jenis satuan
   data_cmd.commandText = "SELECT Sat_ID,Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

   set psatuan = data_cmd.execute

   call header("Detail B.O.M")
%>
<!--#include file="../../navbar.asp"-->
<style>
.clearfixbom {
  padding: 80px 0;
  text-align: center;
  display:none;
  position:absolute;
  width:inherit;
  overflow:hidden;
}
</style>
<div class="container">
   <div class="row">
      <div class="col-lg-12  mt-3 text-center">
         <h3>DETAIL BARANG B.O.M</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 mb-3 text-center">
         <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100" />
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center mb-3 labelId">
         <h3><%= left(id,2) %>-<%=mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,3) %></h3>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-2">
         <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-sm-4 mb-3">
         <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(data("BMDate")) %>" readonly>
      </div>
      <div class="col-sm-2">
         <label for="cabang" class="col-form-label">Cabang</label>
      </div>
      <div class="col-sm-4 mb-3">
         <input type="text" id="cabang" class="form-control" name="cabang" value="<%= data("agenName") %>" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-2">
         <label for="barang" class="col-form-label">Barang</label>
      </div>
      <div class="col-sm-4 mb-3">
         <input type="text" id="barang" class="form-control" name="barang" value="<%= data("Brg_Nama") %>" readonly>
      </div>
      <div class="col-sm-2">
         <label for="approve" class="col-form-label">Approve Y/N</label>
      </div>
      <div class="col-sm-4 mb-3">
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="approve" id="approveY" value="Y" <% if data("BMApproveYN") = "Y" then%>checked <% end if %>disabled>
            <label class="form-check-label" for="approveY">Yes</label>
         </div>
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="approve" id="approveN" value="N" <% if data("BMApproveYN") = "N" then%>checked <% end if %>disabled>
            <label class="form-check-label" for="approveN" >No</label>
         </div>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-2">
         <label for="sasisid" class="col-form-label">No. Drawing</label>
      </div>
      <div class="col-sm-4 mb-3">
         <input type="text" class="form-control" name="sasisid" id="sasisid" maxlength="50" autocomplete="off" value="<%= LEft(data("BMSasisID"),5) &"-"& mid(data("BMSasisID"),6,4) &"-"& right(data("BMSasisID"),3) %>" readonly>
      </div>
      <div class="col-sm-2">
         <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-sm-4 mb-3">
         <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="50" autocomplete="off" value="<%= data("BMKeterangan") %>" readonly>
      </div>
   </div>
   <div class="row">
   <div class="col-lg-12">
      <div class="d-flex mb-3">
            <div class="me-auto p-2">
               <button type="button" class="btn btn-primary btn-modalbomd" data-bs-toggle="modal" data-bs-target="#modalbomd">Tambah Rincian</button>
            </div>
            <div class="p-2">
               <a href="index.asp" class="btn btn-danger">Kembali</a>
            </div>
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
                    do while not ddata.eof 
                    %>
                        <tr>
                           <th>
                              <%= left(ddata("bmDbmID"),2) %>-<%=mid(ddata("bmDbmID"),3,3) %>/<%= mid(ddata("bmDbmID"),6,4) %>/<%= mid(ddata("BMDBMID"),10,3) %>/<%= right(ddata("BMDBMID"),3) %>
                           </th>
                           <td>
                              <%= ddata("kategoriNama") &"-"& ddata("JenisNama") %>
                           </td>
                           <td>
                              <%= ddata("Brg_Nama") %>
                           </td>
                           <td>
                              <%= ddata("bmDQtty") %>
                           </td>
                           <td>
                              <%= ddata("sat_nama") %>
                           </td>
                           <td class="text-center">
                              <div class="btn-group" role="group" aria-label="Basic example">
                              <a href="aktifd.asp?id=<%= ddata("bmDbmID") %>&p=bom_u" class="btn badge text-bg-danger" onclick="deleteItem(event,'delete detail bom')">Delete</a>
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
<div class="modal fade" id="modalbomd" tabindex="-1" aria-labelledby="modalbomdLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header">
         <h5 class="modal-title" id="modalbomdLabel">Rincian Barang</h5>
         <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
      <form action="bom_u.asp?id=<%= id %>" method="post" id="formbomd" onsubmit="validasiForm(this,event,'Detail Barang B.O.M','warning')">
      <input type="hidden" name="bmid" id="bmid" value="<%= id %>">
      <input type="hidden" name="notbrgid" id="notbrgid" value="<%= data("BMBrgID") %>">
         <div class="modal-body">
         <!-- table barang -->
         <div class="row">
            <div class="col-sm-3">
               <label for="cdetailbom" class="col-form-label">Cari Barang</label>
            </div>
            <div class="col-sm-9 mb-3">
               <!-- cari nama barang -->
               <input type="text" id="cdetailbom" class="form-control" name="cdetailbom" autocomplete="off"> 
               <!-- cabang -->
               <input type="hidden" id="bomdCabang" class="form-control" name="bomdCabang" value="<%= data("bmAgenID") %>" autocomplete="off"> 
               <!-- id bom
               <input type="hidden" id="productID" class="form-control" name="productID" value="<%'= data("bmBrgID") %>" autocomplete="off"> 
                -->
            </div>
         </div>
         <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
               <table class="table" style="font-size:12px;">
                  <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                     <tr>
                        <th scope="col">Kode</th>
                        <th scope="col">Nama</th>
                        <th scope="col">Pilih</th>
                     </tr>
                  </thead>
                  <!-- loader -->
                  <div class="clearfixbom">
                     <img src="../../public/img/loader.gif" width="50">
                  </div>
                  <tbody class="contentBOMD">
                     <% do while not barang.eof %>
                     <tr>
                        <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
                        <td><%= barang("brg_nama") %></td>
                        <td>
                           <div class="form-check">
                                 <input class="form-check-input" type="radio" name="ckproduckd" id="ckproduckd" value="<%= barang("Brg_ID") %>" required>
                           </div>
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
         <!-- end table -->
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
      call updatebomD()
   end if
   call footer()
%>