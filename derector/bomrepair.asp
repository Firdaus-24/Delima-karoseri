<!--#include file="../connections/cargo.asp"-->
<!--#include file="../url.asp"-->
<% 
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

%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Detail Bom Repair</title>
  <link href="../public/css/bootstrap.min.css" rel="stylesheet" />
  <script src="../public/js/bootstrap.bundle.min.js"></script>
  <!-- sweet alert -->
  <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  <link href='../public/img/delimalogo.png' rel='website icon' type='png' />
</head>
<body>
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
        <h3>DETAIL B.O.M REPAIR</h3>
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
      <label for="salary" class="col-form-label">Anggaran Manpower</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" class="form-control" name="salary" id="salary-bomrepaird" value="<%=Replace(formatCurrency(data("BmrTotalSalary")),"$","")%>" autocomplete="off" readonly>
    </div>
    <div class="col-sm-2">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="100" value="<%=data("BmrKeterangan")%>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 d-flex justify-content-between ">
      <button type="button" onclick="window.location.href='./'" class="btn btn-danger">Kembali</button>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-12 mb-3">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Kategori</th>
            <th scope="col">Jenis</th>
            <th scope="col">Barang</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Keterangan</th>
          </tr>
        </thead>
        <tbody>
          <% 
          gettotal = 0
          total = 0
          no = 0
          do while not ddata.eof 
          no = no + 1

          ' get data harga purchase
          data_cmd.commandTExt = "SELECT ISNULL(MAX(Dven_Harga),0) as harga FROM DLK_T_VendorD where Dven_BrgID = '"& ddata("BmrdBrgID") &"'"
          set ckharga = data_cmd.execute

          total = ckharga("harga") * ddata("BmrdQtysatuan")
          gtotal = gtotal + total
          %>
            <tr>
              <th>
                <%= no %>
              </th>
              <td>
                <%=ddata("KategoriNama") %>
              </td>
              <td>
                <%= ddata("jenisNama") %>
              </td>
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
 <!-- jquery -->
  <script src="../../public/js/jquery-min.js"></script>
  <!-- bootstrap -->
  <script src="../../public/js/bootstrap.min.js"></script>
</body>
</html>