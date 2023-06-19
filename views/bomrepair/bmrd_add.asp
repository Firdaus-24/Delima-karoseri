<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_bomrepair.asp"-->
<% 
  if (session("PP6A") = false) And (session("PP6B") = false) then
    Response.Redirect("./")
  end if
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' data header
  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama, dbo.DLK_M_Brand.BrandName, dbo.DLK_T_UnitCustomerD1.TFK_Nopol, dbo.DLK_T_UnitCustomerD1.TFK_Type, dbo.DLK_T_BOMRepairH.* FROM  dbo.DLK_M_Customer INNER JOIN dbo.DLK_T_IncRepairH ON dbo.DLK_M_Customer.custId = LEFT(dbo.DLK_T_IncRepairH.IRH_TFKID, 11) INNER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_T_IncRepairH.IRH_TFKID = dbo.DLK_T_UnitCustomerD1.TFK_ID INNER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_BrandID = dbo.DLK_M_Brand.BrandID RIGHT OUTER JOIN dbo.DLK_T_BOMRepairH ON dbo.DLK_T_IncRepairH.IRH_ID = dbo.DLK_T_BOMRepairH.BmrIRHID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMRepairH.BmrAgenId = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_BOMRepairH.BmrID = '"& id &"') AND (dbo.DLK_T_BOMRepairH.BmrAktifYN = 'Y')"
  set data = data_cmd.execute    

  ' data detail
  data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_BOMRepairD.*, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama FROM  dbo.DLK_M_JenisBarang RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_BOMRepairD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMRepairD.BmrdSatID = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_BOMRepairD.BmrdBrgID WHERE LEFT(DLK_T_BOMRepairD.BmrdID,13) = '"& data("BmrID") &"' ORDER BY Brg_Nama ASC"
  ' Response.Write data_cmd.commandTExt & "<br>"
  set ddata = data_cmd.execute

  ' barang
  data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Barang LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId WHERE (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_TypeBarang.T_ID HAVING (LEFT(dbo.DLK_M_Barang.Brg_Id, 3) = '"& data("BmrAgenID") &"') AND (dbo.DLK_M_TypeBarang.T_ID <> 'T01') AND (dbo.DLK_M_TypeBarang.T_ID <> 'T02') AND ( dbo.DLK_M_TypeBarang.T_ID <> 'T05') AND ( dbo.DLK_M_TypeBarang.T_ID <> 'T06')  ORDER BY dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_Barang.Brg_Nama"

  set barang = data_cmd.execute

  ' get satuan barang
  data_cmd.commandTExt = "SELECT Sat_Nama, Sat_ID FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"
  set psatuan = data_cmd.execute

  call header("From B.O.M Repair") 
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
    <div class="col-lg-12 mt-3 text-center">
        <h3>FORM DETAIL B.O.M REPAIR</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%=left(data("BMRID"),3)&"-"&MID(data("BMRID"),4,3)&"/"&MID(data("BMRID"),7,4)&"/"&right(data("BMRID"),3)%></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(data("BmrDate")) %>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="cabang" class="col-form-label">Cabang</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="cabang" class="form-control" name="cabang" value="<%= data("AgenName") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="pdrid" class="col-form-label">No. Produksi</label>
    </div>
    <div class="col-sm-4 mb-3">
    <input type="text" id="pdrid" class="form-control" name="pdrid" value="<%=LEFT(data("BMRPDRID"),3) &"-"& MID(data("BMRPDRID"),4,2) &"/"& RIGHT(data("BMRPDRID"),3) %>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="irhid" class="col-form-label">No.Incomming Unit</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" class="form-control" name="irhid" value="<%=LEFT(data("BmrIRHID"),4) &"-"& mid(data("BmrIRHID"),5,3) &"/"& mid(data("BmrIRHID"),8,4) &"/"& right(data("BmrIRHID"),2)%>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="cust" class="col-form-label">Customer</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="cust-bomrepaird" class="form-control" name="cust" value="<%=data("custnama")%>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="brand" class="col-form-label">Brand</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="brand-bomrepaird" class="form-control" name="brand" value="<%=data("BrandName")%>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="type" class="col-form-label">Type</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="type-bomrepaird" class="form-control" name="type" value="<%=data("TFK_Type")%>"  readonly>
    </div>
    <div class="col-sm-2">
      <label for="nopol" class="col-form-label">No.Polisi</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="nopol-bomrepaird" class="form-control" name="nopol" value="<%=data("TFK_Nopol")%>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label for="tmanpower" class="col-form-label">Total Man Power</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="number" id="tmanpower" class="form-control" name="tmanpower" value="<%=data("BmrManPower")%>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="salary" class="col-form-label">Anggaran Manpower</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" class="form-control" name="salary" id="salary-bomrepaird" value="<%=Replace(formatCurrency(data("BmrTotalSalary")),"$","")%>" autocomplete="off" readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-sm-2">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-sm-10 mb-3">
      <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="100" value="<%=data("BmrKeterangan")%>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 d-flex justify-content-between ">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalBmrdRepair">Tambah Rincian</button>
      <button type="button" onclick="window.location.href='./'" class="btn btn-danger">Kembali</button>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-12 mb-3">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Kode</th>
            <th scope="col">Barang</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
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
                <%= no %>
              </th>
              <th>
                <%= ddata("KategoriNama") &" - "& ddata("jenisNama") %>
              </th>
              <td>
                <%=ddata("Brg_Nama")%>
              </td>
              <td>
                <%= ddata("BmrdQtysatuan")%>
              </td>
              <td>
                <%= ddata("Sat_nama")%>
              </td>
              <td>
                <%= ddata("BmrdKeterangan")%>
              </td>
              <td class="text-center">
                <a href="aktifd.asp?id=<%= ddata("BmrDID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Item BOM Repair')">Delete</a>
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
<div class="modal fade" id="modalBmrdRepair" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalBmrdRepairLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalBmrdRepairLabel">Modal Detail B.O.M Repair</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <form action="bmrd_add.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Detail B.O.M Repair','warning')">
        <div class="modal-body">
          <input type="hidden" name="bmrid" id="bmrid" value="<%= id %>">
          <!-- table barang -->
          <div class="row">
            <div class="col-sm-3">
              <label for="cdetailbom" class="col-form-label">Cari Barang</label>
            </div>
            <div class="col-sm-9 mb-3">
              <!-- cari nama barang -->
              <input type="text" id="cbrgbmrd" class="form-control" name="cbrgbmrd" autocomplete="off"> 
              <!-- cabang -->
              <input type="hidden" id="bmrdCabang-repair" class="form-control" name="bmrdCabang" value="<%= data("bmrAgenID") %>" autocomplete="off"> 
            </div>
          </div>
          <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
              <table class="table" style="font-size:12px;">
                <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                  <tr>
                    <th scope="col">Kode</th>
                    <th scope="col">Nama</th>
                    <th scope="col">Type</th>
                    <th scope="col">Pilih</th>
                  </tr>
                </thead>
                <!-- loader -->
                <div class="clearfixbom">
                  <img src="../../public/img/loader.gif" width="50">
                </div>
                <tbody class="brgBmrdRepair">
                  <% do while not barang.eof %>
                  <tr>
                    <th scope="row"><%= barang("kategoriNama")&" - "& barang("jenisNama") %></th>
                    <td><%= barang("brg_nama") %></td>
                    <td><%= barang("T_Nama") %></td>
                    <td>
                      <div class="form-check">
                        <input class="form-check-input" type="radio" name="ckbmrdbrg" id="ckbmrdbrg" value="<%= barang("Brg_ID") %>" required>
                      </div>
                    </td>
                  </tr>
                  <% 
                  Response.flush
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
                Response.flush
                psatuan.movenext
                loop
                %>
              </select>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-3">
              <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-sm-9 mb-3">
              <input type="text" id="keterangan" class="form-control" name="keterangan" autocomplete="off" maxlength="50">
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
    call tambahbomD()
  end if
  call footer() 
%>