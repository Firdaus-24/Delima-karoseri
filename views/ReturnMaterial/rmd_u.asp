<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_ReturnMaterial.asp"-->
<% 
  if session("PP3B") = false then
    Response.Redirect("index.asp")
  end if
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.DLK_T_ReturnMaterialH.*, dbo.DLK_M_WebLogin.UserName, dbo.GLB_M_Agen.AgenName FROM DLK_T_ReturnMaterialH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ReturnMaterialH.RM_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ReturnMaterialH.RM_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_ReturnMaterialH.RM_AktifYN = 'Y') AND (dbo.DLK_T_ReturnMaterialH.RM_ID = '"&id&"')"

  set data = data_cmd.execute

  ' detail
  data_cmd.commandText = "SELECT dbo.DLK_T_ReturnMaterialD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_SatuanBarang.Sat_Nama, DLK_M_SatuanPanjang.SP_Nama FROM dbo.DLK_M_WebLogin RIGHT OUTER JOIN dbo.DLK_T_ReturnMaterialD INNER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_ReturnMaterialD.RM_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_WebLogin.UserID = dbo.DLK_T_ReturnMaterialD.RM_UpdateID LEFT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_T_ReturnMaterialD.RM_Item = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN DLK_M_SatuanPanjang ON DLK_T_ReturnMaterialD.RM_SPID = SP_ID WHERE LEFT(DLK_T_ReturnMaterialD.RM_ID,13) = '"& data("RM_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama"
  ' response.write data_cmd.commandTExt & "<br>"
  set ddata = data_cmd.execute

  ' penerimaan barang produksi
  data_cmd.commandTExt = "SELECT SUM( ISNULL(dbo.DLK_T_RCProdD.RCD_QtySatuan, 0 )) AS qty, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_T_RCProdD.RCD_Item FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_RCProdD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_RCProdD.RCD_Item LEFT OUTER JOIN dbo.DLK_T_RCProdH ON LEFT(dbo.DLK_T_RCProdD.RCD_ID, 10) = dbo.DLK_T_RCProdH.RC_ID WHERE (LEFT(dbo.DLK_T_RCProdH.RC_PDDID, 13) = '"& data("RM_PDHID") &"') AND DLK_T_RCProdH.RC_AktifYN = 'Y' GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_RCProdH.RC_AktifYN, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_T_RCProdD.RCD_Item ORDER BY BRG_NAma"
  ' response.write data_cmd.commandText & "<br>"
  set getbarang = data_cmd.execute   

  ' satuan
  data_cmd.commandTExt = "SELECT Sat_ID, Sat_Nama FROM DLK_M_satuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"
  
  set getsatuan = data_cmd.execute

  ' satuan panjang
  data_cmd.commandTExt = "SELECT SP_ID, SP_Nama FROM DLK_M_satuanPanjang WHERE SP_AktifYN = 'Y' ORDER BY SP_ID ASC"
  
  set getpanjang = data_cmd.execute

  call header("UPDATE DETAIL RETURN MATERIAL")

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>UPDATE DETAIL RETURN MATERIAL PRODUKSI</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= left(data("RM_ID") ,2)%>-<%= mid(data("RM_ID") ,3,3)%>/<%= mid(data("RM_ID") ,6,4) %>/<%= right(data("RM_ID"),4) %></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="cabang" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= data("AgenName") %>"  readonly>
    </div>
    <div class="col-sm-2">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(data("RM_Date")) %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="agen" class="col-form-label">No.Produksi</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= left(data("RM_PDHID"),2) %>-<%= mid(data("RM_PDHID"),3,3) %>/<%= mid(data("RM_PDHID"),6,4) %>/<%= right(data("RM_PDHID"),4)  %>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="updateid" class="col-form-label">UpdateID</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= data("username") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="Terima" class="col-form-label">Serah Terima</label>
    </div>
    <div class="col-sm-4 mb-3">
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="Y" <% if data("RM_TerimaYN") = "Y" then%>checked <% end if %>disabled>
        <label class="form-check-label" for="Y" >Done</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="N" <% if data("RM_TerimaYN") = "N" then%>checked <% end if %>disabled
        > 
        <label class="form-check-label" for="N" >Waiting</label>
      </div>
    </div>
    <div class="col-sm-2">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" value="<%= data("RM_Keterangan") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 d-flex justify-content-between">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalReturMaterial">Tambah Rincian</button>
      <button type="button" class="btn btn-danger" onclick="window.location.href='index.asp'">Kembali</button>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 mt-3">
      <table class="table" >
        <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Kode</th>
            <th scope="col">Item</th>
            <th scope="col">Dimension</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Total Qty</th>
            <th scope="col">Harga</th>
            <th scope="col">UpdateID</th>
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
            <th scope="row"><%= no %></th>
            <th><%= ddata("KategoriNama") %>-<%= ddata("jenisNama") %></th>
            <td>
              <%= ddata("Brg_Nama") %>
            </td>
            <td><%= ddata("RM_Dimension") %></td>
            <td><%= ddata("RM_qtysatuan") %></td>
            <td><%= ddata("sat_nama") %></td>
            <td class="text-end"><%= ddata("RM_TotalQtyMM") &" "& ddata("SP_Nama") %></td>
            <td>
              <%= replace(formatCurrency(ddata("RM_Harga")),"$","") %>
            </td>
            <td><%= ddata("username") %></td>
            <td class="text-center">
              <a href="aktifd.asp?id=<%= ddata("RM_ID") %>&p=rmd_u" class="btn badge text-bg-danger" onclick="deleteItem(event, 'RETURN MATERIAL PRODUKSI')">delete</a>
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
<div class="modal fade" id="modalReturMaterial" tabindex="-1" aria-labelledby="modalReturMaterialLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalReturMaterialLabel">Detail Barang</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>


      <form action="rmd_u.asp?id=<%= id %>" method="post" onsubmit="validasiReturnMaterial(this,event)">
        <input type="hidden" name="rmid" id="rmid" value="<%= id %>">
        <input type="hidden" name="pdhidrm" id="pdhidrm" value="<%= data("RM_PDHID") %>">
        <input type="hidden" id="nqty">
        <div class="modal-body">
        <!-- cari barang -->
        <div class="row">
          <div class="col-sm-3">
            <label for="cariRM" class="col-form-label">Cari Barang</label>
          </div>
          <div class="col-sm mb-3">
            <input type="text" id="cariRM" class="form-control" name="cariRM" autocomplete="off">
          </div>
        </div>
        <!-- table barang -->
        <div class="row">
          <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
            <table class="table" style="font-size:12px;">
              <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                <tr>
                  <th scope="col">No</th>
                  <th scope="col">Kode</th>
                  <th scope="col">Item</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Pilih</th>
                </tr>
              </thead>
              <tbody  class="contentRM">
              <% 
                angka = 0
                do while not getbarang.eof 
                angka = angka + 1
                %>
                <tr>
                  <th>
                    <%= angka %>
                  </th>
                  <th>
                    <%= getbarang("KategoriNama") &"-"& getbarang("jenisNama") %>
                  </th>
                  <td>
                    <%= getbarang("Brg_Nama") %>
                  </td>
                  <td>
                    <%= getbarang("qty") %>
                  </td>
                  <td>
                      <input class="form-check-input" type="radio" value="<%= getbarang("RCD_Item") %>" name="item" id="item" onchange="getHargaRC('<%= getbarang("RCD_Item") %>','<%= getbarang("qty") %>')" required>
                  </td>
                </tr>
              <% 
                response.flush
                getbarang.movenext
                loop
              %>
              </tbody>
            </table>
          </div>
        </div>
        <!-- end table -->
        <div class="row">
          <div class="col-sm-4">
            <label for="hargaoutgoing" class="col-form-label">Harga Pokok</label>
          </div>
          <div class="col-sm-8 mb-3">
            <input type="text" id="hargaRC" class="form-control" name="hargaoutgoing" readonly>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-4">
            <label for="dimensi" class="col-form-label">Dimension</label>
          </div>
          <div class="col-sm-8 mb-3">
            <input type="text" id="dimensi" class="form-control" name="dimensi" maxlenght="100" autocomplete="off" required>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-4">
            <label for="qtty" class="col-form-label">Quantity</label>
          </div>
          <div class="col-sm-6 mb-3">
            <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-4">
            <label for="satuan" class="col-form-label">Satuan Barang</label>
          </div>
          <div class="col-sm-6 mb-3">
            <select class="form-select" aria-label="Default select example" name="satuan" id="satuan" required> 
              <option value="">Pilih</option>
              <% do while not getsatuan.eof %>
              <option value="<%= getsatuan("sat_ID") %>"><%= getsatuan("sat_nama") %></option>
              <%  
              getsatuan.movenext
              loop
              %>
            </select>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-4">
            <label for="totalqtty" class="col-form-label">Total Quantity</label>
          </div>
          <div class="col-sm-6 mb-3">
            <input type="text" id="totalqtty" class="form-control" name="totalqtty" autocomplete="off" required>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-4">
            <label for="panjang" class="col-form-label">Satuan Panjang</label>
          </div>
          <div class="col-sm-6 mb-3">
            <select class="form-select" aria-label="Default select example" name="panjang" id="panjang" required> 
              <option value="">Pilih</option>
              <% do while not getpanjang.eof %>
              <option value="<%= getpanjang("SP_ID") %>"><%= getpanjang("SP_nama") %></option>
              <%  
              getpanjang.movenext
              loop
              %>
            </select>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-4">
            <label for="harga" class="col-form-label">Harga Satuan</label>
          </div>
          <div class="col-sm-6 mb-3">
            <input type="number" id="harga" class="form-control" name="harga" autocomplete="off" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Save</button>
        </div>
      </div>
      </form>

    </div>
  </div>
</div>
<% 
  if request.serverVariables("REQUEST_METHOD") = "POST" then
    call updatedetailRM()
  end if
  call footer()
%>