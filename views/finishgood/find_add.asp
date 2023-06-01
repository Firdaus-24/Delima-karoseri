<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_finishgood.asp"--> 
<% 
   '  if session("PP1A") = false then
   '      Response.Redirect("index.asp")
   '  end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' get data header
   data_cmd.commandText = "SELECT dbo.DLK_T_ProdFinishH.*, dbo.DLK_M_WebLogin.username, GLB_M_Agen.AgenName FROM dbo.DLK_T_ProdFinishH LEFT OUTER JOIN dbo.DLK_M_Weblogin ON dbo.DLK_T_ProdFinishH.PFH_UpdateID = dbo.DLK_M_webLogin.userID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProdFinishH.PFH_agenID = GLB_M_agen.AgenID WHERE PFH_AktifYN = 'Y' AND PFH_ID = '"& id &"'"

   set data = data_cmd.execute

   ' get data detail
   data_cmd.commandText = "SELECT dbo.DLK_T_ProdFinishD.PFD_UpdateID, dbo.DLK_T_ProdFinishD.PFD_Harga, dbo.DLK_T_ProdFinishD.PFD_Item, dbo.DLK_T_ProdFinishD.PFD_SalMP, dbo.DLK_T_ProdFinishD.PFD_MP, dbo.DLK_T_ProdFinishD.PFD_FDate, dbo.DLK_T_ProdFinishD.PFD_RCID, dbo.DLK_T_ProdFinishD.PFD_PDDID, dbo.DLK_T_ProdFinishD.PFD_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_ProdFinishH RIGHT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.DLK_T_ProdFinishD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_ProdFinishD.PFD_Item ON dbo.DLK_T_ProdFinishH.PFH_ID = LEFT(dbo.DLK_T_ProdFinishD.PFD_ID, 13) WHERE LEFT(dbo.DLK_T_ProdFinishD.PFD_ID,13) = '"& data("PFH_ID") &"' ORDER BY Brg_nama ASC"

   set ddata = data_cmd.execute

   ' get barang di terima keruang produksi
   data_cmd.commandText = "SELECT dbo.DLK_T_RCProdH.RC_PDDID, dbo.DLK_T_RCProdH.RC_ID, ISNULL(dbo.DLK_M_Sasis.SasisType, '') AS type, ISNULL(dbo.DLK_M_Brand.BrandName, '') AS brand, ISNULL(dbo.DLK_M_Class.ClassName, '') AS class, dbo.DLK_T_RCProdH.RC_MP FROM dbo.DLK_M_BOMH INNER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID INNER JOIN dbo.DLK_M_Sasis ON dbo.DLK_M_BOMH.BMSasisID = dbo.DLK_M_Sasis.SasisID INNER JOIN dbo.DLK_M_Class ON dbo.DLK_M_Sasis.SasisClassID = dbo.DLK_M_Class.ClassID INNER JOIN dbo.DLK_M_Brand ON dbo.DLK_M_Sasis.SasisBrandID = dbo.DLK_M_Brand.BrandID RIGHT OUTER JOIN dbo.DLK_T_RCProdH ON dbo.DLK_T_ProduksiD.PDD_ID = dbo.DLK_T_RCProdH.RC_PDDID WHERE (dbo.DLK_T_RCProdH.RC_AktifYN = 'Y') AND NOT EXISTS(SELECT PFD_RCID FROM dbo.DLK_T_ProdFinishD WHERE dbo.DLK_T_ProdFinishD.PFD_RCID = dbo.DLK_T_RCProdH.RC_ID) ORDER BY dbo.DLK_T_RCProdH.RC_PDDID ASC"

   set getbarang = data_cmd.execute

   call header("Detail Transaksi")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12  mt-3 text-center">
         <h3>DETAIL TRANSAKSI FINISH GOOD</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center mb-3 labelId">
         <h3><%= left(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"& right(id,4) %></h3>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-4 mb-3 ">
         <label>Tanggal :</label>
         <input name="tgl" id="tgl" type="text" class="form-control" value="<%= cdate(data("PFH_Date")) %>" readonly>
      </div>
      <div class="col-sm-4 mb-3">
         <label>Cabang :</label>
         <input name="pddid" id="pddid" type="text" class="form-control" value="<%= data("agenName") %>" readonly>
      </div>
      <div class="col-sm-4 mb-3 ">
         <label>Update ID :</label>
         <input name="update" id="update" type="text" class="form-control" value="<%= data("username") %>" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-4 mb-3 ">
         <label>No Document :</label>
         <input name="nodoc" id="nodoc" type="text" class="form-control" value="<%= left(data("PFH_PDHid"),2)&"-"&mid(data("PFH_PDHid"),3,3) &"/"& mid(data("PFH_PDHid"),6,4) &"/"&  right(data("PFH_PDHid"),4)  %>" readonly>
      </div>
      <div class="col-sm-8 mb-3">
         <label>Keterangan :</label>
         <input name="keterangan" id="keterangan" type="text" class="form-control" value="<%= data("PFH_keterangan") %>" maxlength="50" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12">
         <div class="d-flex mb-3">
            <div class="me-auto p-2">
               <button type="button" class="btn btn-primary btn-modalFinishGood" data-bs-toggle="modal" data-bs-target="#modalFinishGood">Tambah Rincian</button>
            </div>
            <div class="p-2">
               <a href="index.asp" class="btn btn-danger">Kembali</a>
            </div>
         </div>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 ">
         <table class="table table-hover">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">Tanggal</th>
                  <th scope="col">No.Produksi</th>
                  <th scope="col">Kode</th>
                  <th scope="col">Item</th>
                  <th scope="col">Man Power</th>
                  <th scope="col">Salary ManPower</th>
                  <th scope="col">Harga</th>
                  <th scope="col" class="text-center">Aksi</th>
               </tr>
            </thead>
            <tbody>
               <% 
               do while not ddata.eof 
               %>
               <tr>
                  <td>
                     <%= Cdate(ddata("PFD_FDate")) %>
                  </td>
                  <td>
                     <%= ddata("PFD_PDDID") %>
                  </td>
                  <td>
                     <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                  </td>
                  <td>
                     <%= ddata("Brg_Nama") %>
                  </td>
                  <td>
                     <%= ddata("PFD_MP") %>
                  </td>
                  <td>
                     <%= ddata("PFD_SalMP") %>
                  </td>
                  <td>
                     <%= ddata("PFD_Harga") %>
                  </td>
                  <td class="text-center">
                     <%' if session("PP1C") = true then  %>
                     <div class="btn-group" role="group" aria-label="Basic example">
                     <a href="aktifd.asp?id=<%= ddata("PFD_ID") %>&p=fin_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'hapus detail transaksi')">Delete</a>
                     <% 'end if %>
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
<div class="modal fade" id="modalFinishGood" tabindex="-1" aria-labelledby="modalFinishGoodLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header">
            <h5 class="modal-title" id="modalFinishGoodLabel">Rincian Produksi</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
      <form action="rcd_add.asp?id=<%= id %>" method="post">
         <input type="hidden" name="pfhid" id="pfhid" value="<%= id %>">
         <div class="modal-body">
         <!-- table barang -->
         <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
               <table class="table" style="font-size:12px;">
                  <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                     <tr>
                        <th scope="col">No Produksi</th>
                        <th scope="col">Class</th>
                        <th scope="col">Type</th>
                        <th scope="col">Brand</th>
                        <th scope="col">Pilih</th>
                     </tr>
                  </thead>
                  <tbody  class="contentrc">
                  <% 
                     do while not getbarang.eof 
                     %>
                     <tr>
                        <th>
                           <%= left(getbarang("RC_PDDID"),2) %>-<%= mid(getbarang("RC_PDDID"),3,3) %>/<%= mid(getbarang("RC_PDDID"),6,4) %>/<%= mid(getbarang("RC_PDDID"),10,4) %>/<%= right(getbarang("RC_PDDID"),3)  %>
                        </th>
                        <td>
                           <%= getbarang("class") %>
                        </td>
                        <td>
                           <%= getbarang("type") %>
                        </td>
                        <td>
                           <%= getbarang("brand") %>
                        </td>
                        <td>
                           <input class="form-check-input" type="radio" value="<%= getbarang("RC_ID") %>" name="pddid" id="pddid" onclick="getRCID('<%= getbarang("RC_PDDID") %>')" required>
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
               <div class="col-sm-4">
                  <label for="tgl" class="col-form-label">Tanggal</label>
               </div>
               <div class="col-sm-4 mb-3">
                  <input type="text" id="tgl" class="form-control" name="tgl" value="<%= date %>" autocomplete="off" onfocus="(this.type='date')" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-4">
                  <label for="mp" class="col-form-label">Man Power</label>
               </div>
               <div class="col-sm-4 mb-3">
                  <input type="number" id="mp" class="form-control" name="mp" autocomplete="off" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-4">
                  <label for="mp" class="col-form-label">Salary ManPower</label>
               </div>
               <div class="col-sm-6 mb-3">
                  <input type="number" id="mp" class="form-control" name="mp" autocomplete="off" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-4 mb-3">
                  <label for="tharga" class="col-form-label">Total Harga</label>
               </div>
               <div class="col-sm-6">
                  <input type="text" id="tharga" name="tharga" autocomplete="off" class="form-control" readonly>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-4">
                  <label for="upto" class="col-form-label">Persentase</label>
               </div>
               <div class="col-sm-6 mb-3">
                  <input type="number" id="upto" class="form-control" name="upto" autocomplete="off" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-4">
                  <label for="hpp" class="col-form-label">HPP</label>
               </div>
               <div class="col-sm-6 mb-3">
                  <input type="text" id="hpp" class="form-control" name="hpp" autocomplete="off" readonly>
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
const getHarga = (e) => {
   $("#harga").val(e)
}

</script>

<% 
   if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
     call detailrc()
   end if
   call footer()
%>