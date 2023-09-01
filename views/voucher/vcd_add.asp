<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_voucher.asp"-->
<% 
if (session("PP9A") = false  OR session("PP9A") = "") AND (session("PP9B") = false OR session("PP9B") = "") then
    Response.Redirect("./")
  end if
  id =  trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' data header
  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_T_VoucherH.* FROM dbo.DLK_T_VoucherH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_VoucherH.VCH_Agenid = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_VoucherH.VCH_AktifYN = 'Y') AND (dbo.DLK_T_VoucherH.VCH_id = '"& id &"')"

  set data = data_cmd.execute

  if data.eof then
    Response.Redirect("./")
  end if

  ' detail
  data_cmd.commandTExt = "SELECT dbo.DLK_T_VoucherD.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID RIGHT OUTER JOIN dbo.DLK_T_VoucherD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_VoucherD.VCH_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_VoucherD.VCH_Satid = dbo.DLK_M_SatuanBarang.Sat_ID WHERE LEFT(DLK_T_VoucherD.VCH_VCHID,13) = '"& data("VCH_ID") &"' ORDER BY Brg_Nama, T_Nama ASC"

  set ddata = data_cmd.execute

  if data("VCH_Type") = "N" then
    ' daftar bom new produksi
    data_cmd.commandTExt = "SELECT dbo.DLK_T_ProduksiD.PDD_ID, dbo.DLK_T_ProduksiD.PDD_BMID, (dbo.DLK_M_BOMD.BMDQtty) as qty, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID INNER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID RIGHT OUTER JOIN dbo.DLK_M_BOMD INNER JOIN dbo.DLK_M_BOMH ON LEFT(dbo.DLK_M_BOMD.BMDBMID, 12) = dbo.DLK_M_BOMH.BMID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_M_BOMD.BMDJenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_BOMD.BMDItem RIGHT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID WHERE (dbo.DLK_T_ProduksiD.PDD_ID = '"& data("VCH_PDDID") &"') ORDER BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_TypeBarang.T_Nama"

    set databom = data_cmd.execute
  else
    data_cmd.commandTExt = "SELECT (dbo.DLK_T_BOMRepairD.BmrdQtysatuan) as qty, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId INNER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID RIGHT OUTER JOIN dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_T_BOMRepairD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_T_BOMRepairD.BmrdSatID ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_BOMRepairD.BmrdBrgID LEFT OUTER JOIN dbo.DLK_T_BOMRepairH ON LEFT(dbo.DLK_T_BOMRepairD.BmrdID, 13) = dbo.DLK_T_BOMRepairH.BmrID WHERE dbo.DLK_T_BOMRepairH.Bmrpdrid = '"& data("VCH_PDRID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_TypeBarang.T_Nama"
    
    set databom = data_cmd.execute
  end if

  ' cabang
  data_cmd.commandText = "SELECT AgenName, AgenID FROM dbo.GLB_M_Agen WHERE (AgenAktifYN = 'Y') ORDER BY AgenName"
  ' response.write data_cmd.commandText & "<br>"
  set agendata = data_cmd.execute
  ' satuan
  data_cmd.commandText = "SELECT Sat_nama, sat_id FROM dbo.DLK_M_satuanbarang WHERE (sat_aktifyn = 'Y') ORDER BY Sat_nama"
  ' response.write data_cmd.commandText & "<br>"
  set psatuan = data_cmd.execute

  ' New Produksi
  data_cmd.commandText = "SELECT dbo.DLK_T_ProduksiD.PDD_ID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_ProduksiH INNER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_T_ProduksiH.PDH_ID = LEFT(dbo.DLK_T_ProduksiD.PDD_ID, 13) LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProduksiD.PDD_Item = dbo.DLK_M_Barang.Brg_Id WHERE (dbo.DLK_T_ProduksiH.PDH_Approve2 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve1 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_AktifYN = 'Y') GROUP BY dbo.DLK_T_ProduksiD.PDD_ID, dbo.DLK_M_Barang.Brg_Nama ORDER BY dbo.DLK_T_ProduksiD.PDD_ID"
  set newproduksi = data_cmd.execute
  ' repair Produksi
  data_cmd.commandText = "SELECT PDR_ID FROM DLK_T_ProduksiRepair where PDR_AktifYN = 'Y' ORDER BY PDR_ID ASC"
  set repair = data_cmd.execute

  call header("Tambah Voucher")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>FORM TAMBAH VOUCHER</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%=left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)%></h3>
    </div>
  </div>
  <form action="vcd_add.asp?id=<%=id%>" method="post" onsubmit="validasiForm(this,event,'HEADER VOUCHER','warning')">
  <input type="hidden" name="voucherid" id="voucherid" value="">
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="agen" class="col-form-label">Cabang / Agen</label>
      </div>
      <div class="col-lg-4 mb-3">
        <select class="form-select" aria-label="Default select example" id="agen" name="agen" required>
          <option value="<%=data("VCH_Agenid")%>"><%=data("agenname")%></option>
          <% do while not agendata.eof %>
          <option value="<%= agendata("AgenID") %>"><%=agendata("AgenName") %></option>
          <% 
          agendata.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="tprod" class="col-form-label">Type Produksi</label>
      </div>
      <div class="col-lg-4 mb-3">
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="cktprod" id="cktprod1" value="N" onchange="RemoveDesableVoucher($(this).val())" <%if data("VCH_Type") = "N" then %>checked <%end if%>  required>
            <label class="form-check-label" for="cktprod1">
               New Produksi
            </label>
         </div>
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="cktprod" value="R" id="cktprod2"  onchange="RemoveDesableVoucher($(this).val())" <%if data("VCH_Type") = "R" then %>checked <%end if%>>
            <label class="form-check-label" for="cktprod2">
               Produksi Repair
            </label>
         </div>
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="pdhid" class="col-form-label">New Produksi</label>
      </div>
      <div class="col-lg-4 mb-3">
        <select class="form-select" aria-label="Default select example" id="voucherAddpdhid" name="pdhid" <%if data("VCH_PDDID") = "" then%> disabled <%end if%> required>
          <%if data("VCH_PDDID") = "" then%>
            <option value="">Pilih</option>
          <%else%>
            <option value="<%= data("VCH_PDDID") %>"><%= left(data("VCH_PDDID"),2) %>-<%= mid(data("VCH_PDDID"),3,3) %>/<%= mid(data("VCH_PDDID"),6,4) %>/<%= mid(data("VCH_PDDID"),10,4) %>/<%= right(data("VCH_PDDID"),3) %></option>
          <%end if%>
          <% do while not newproduksi.eof %>
          <option value="<%= newproduksi("PDD_ID") %>"><%= left(newproduksi("PDD_ID"),2) %>-<%= mid(newproduksi("PDD_ID"),3,3) %>/<%= mid(newproduksi("PDD_ID"),6,4) %>/<%= mid(newproduksi("PDD_ID"),10,4) %>/<%= right(newproduksi("PDD_ID"),3) %> || <%=newproduksi("brg_nama")%></option>
          <% 
          Response.flush
          newproduksi.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="tgl" name="tgl" value="<%= Cdate(data("VCH_Date")) %>" onfocus="(this.type='date')" class="form-control" required>
      </div>
    </div>
   <div class="row">
      <div class="col-lg-2 mb-3">
        <label for="pdrid" class="col-form-label">Repair Produksi</label>
      </div>
      <div class="col-lg-4 mb-3">
        <select class="form-select" aria-label="Default select example" id="voucherAddpdrid" name="pdrid" <%if data("VCH_PDRID") = "" then%> disabled <%end if%> required>
          <%if data("VCH_PDRID") = "" then%>
            <option value="">Pilih</option>
          <%else%>
            <option value="<%= data("VCH_PDRID") %>"><%= LEFT(data("VCH_PDRID"),3) &"-"& MID(data("VCH_PDRID"),4,2) &"/"& RIGHT(data("VCH_PDRID"),3) %></option>
          <%end if%>
          <% do while not repair.eof %>
          <option value="<%= repair("PDR_ID") %>"><%= LEFT(repair("PDR_ID"),3) &"-"& MID(repair("PDR_ID"),4,2) &"/"& RIGHT(repair("PDR_ID"),3)%></option>
          <% 
          Response.flush
          repair.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="100" value="<%=data("VCH_Keterangan")%>" autocomplete="off">
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center mb-3 d-flex justify-content-between">
        <div class="btn-group" role="group" aria-label="Basic example">
          <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalVoucherd" onclick="tambahVoucherPermintaanBarang()">Tambah Rincian</button>
          <button type="submit" class="btn btn-success">Update Header</button>
        </div>
        <a href="./" type="button" class="btn btn-danger">Kembali</a>
      </div>
   </div>
  </form>
  <div class='row'>
    <div class='col-lg-12'>
      <hr />
    </div>
  </div>

  <div class='row'>
    <div class='col-lg-6 mb-3'>
      <h5 class="text-center">DAFTAR PERMINTAAN</h5>
      <table class="table table-bordered table-hover" style="font-size:12px;">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Kategori</th>
            <th scope="col">Jenis</th>
            <th scope="col">Barang</th>
            <th scope="col">Type</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <%
          no = 0
          do while not ddata.EOF
          no = no + 1
          %>
          <tr>
            <th scope="row"><%=no%></th>
            <td><%=ddata("kategorinama")%></td>
            <td><%=ddata("JenisNama")%></td>
            <td><%=ddata("Brg_Nama")%></td>
            <td><%=ddata("T_Nama")%></td>
            <td><%=ddata("VCH_Qtysatuan")%></td>
            <td><%=ddata("sat_nama")%></td>
            <td class="text-center">
              <% if session("PP9C") = true then %>
                <a href="aktifd.asp?id=<%= ddata("VCH_VCHID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'delete detail voucher')">Delete</a>
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

    <div class='col-lg-6 mb-3'>
      <h5 class="text-center">DAFTAR B.O.M PRODUKSI</h5>
      <table class="table table-bordered table-hover" style="font-size:12px;">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Kategori</th>
            <th scope="col">Jenis</th>
            <th scope="col">Barang</th>
            <th scope="col">Type</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
          </tr>
        </thead>
        <tbody>
          <%
          number = 0
          Do While not databom.eof
          number = number + 1
          %>
            <tr>
              <th><%=number%></th>
              <td><%=databom("kategorinama")%></td>
              <td><%=databom("Jenisnama")%></td>
              <td><%=databom("Brg_Nama")%></td>
              <td><%=databom("T_Nama")%></td>
              <td><%=databom("qty")%></td>
              <td><%=databom("Sat_nama")%></td>
            </tr>
          <%
          Response.flush
          databom.movenext
          Loop
          %>
          <tr>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>  

<!-- Modal -->
<div class="modal fade" id="modalVoucherd" tabindex="-1" aria-labelledby="modalVoucherdLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalVoucherdLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="vcd_add.asp?id=<%= id %>" method="post">
      <input type="hidden" name="voucherid" id="voucherid" value="<%= id %>">
      <div class="modal-body">
        <div class="row">
          <div class="col-sm-3">
            <label for="cpbarangVoucher" class="col-form-label">Cari Barang</label>
          </div>
          <div class="col-sm-9 mb-3">
            <input type="text" id="cpbarangVoucher" class="form-control" name="cpbarangVoucher" autocomplete="off" onkeyup="cpBrgVoucherD(this.value)">
          </div>
        </div>
        <!-- table barang -->
        <div class="row">
          <div class="col-sm mb-4 overflow-auto" style="height:15rem;font-size:12px;">
            <table class="table table-bordered">
              <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                <tr>
                  <th scope="col">Kategori</th>
                  <th scope="col">Jenis</th>
                  <th scope="col">Nama</th>
                  <th scope="col">Type</th>
                  <th scope="col">Pilih</th>
                </tr>
              </thead>
              <tbody  class="contentBrgVoucherdAdd">
              </tbody>
            </table>
          </div>
        </div>
        <!-- end table -->
        <div class="row">
          <div class="col-sm-3">
            <label for="qtty" class="col-form-label">Quantity</label>
          </div>
          <div class="col-sm-3 mb-3">
            <input type="number" id="qttyVoucherpBarang" class="form-control" name="qtty" autocomplete="off" autocomplete="off" step="any" required>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-3">
            <label for="satuan" class="col-form-label">Satuan Barang</label>
          </div>
          <div class="col-sm-4 mb-3">
            <select class="form-select" aria-label="Default select example" name="satuan" id="satuanVoucherpBarang" required> 
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
          <div class="col-sm-3">
            <label for="ket" class="col-form-label">Keterangan</label>
          </div>
          <div class="col-sm-9 mb-3">
            <div class="form-floating">
              <textarea class="form-control" placeholder="detail" id="keteranganVoucherpbarang" name="keterangan" autocomplete="off" maxlength="100"></textarea>
              <label for="keteranganVoucherpbarang">Keterangan</label>
            </div>
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
   if request.ServerVariables("REQUEST_METHOD") = "POST" then
      if Request.Form("voucherid") = "" then
        call updateheader()
      else
        call detail()
      end if
   end if
   call footer()
%>