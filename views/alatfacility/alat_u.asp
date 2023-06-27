<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_alatfacility.asp"-->
<% 
  if session("DJTF1B") = false then
    Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' get data 
  data_cmd.commandText = "SELECT DLK_M_Barang.*, DLK_M_typeBarang.T_Nama, DLK_M_TypeBarang.T_Nama, DLK_M_kategori.KategoriNama, DLK_M_JenisBarang.jenisNama, DLK_M_TypeBarang.T_Nama, DLK_M_kategori.KategoriID, DLK_M_JenisBarang.jenisID FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_TYpeBarang ON DLK_M_Barang.Brg_Type = DLK_M_TypeBarang.T_ID LEFT OUTER JOIN DLK_M_KAtegori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.jenisID = DLK_M_JenisBarang.JenisID WHERE Brg_ID = '"& id &"' AND Brg_AktifYN = 'Y'"
  set data = data_cmd.execute
  ' cabang
  data_cmd.commandText = "SELECT AgenID, AgenNAme FROM GLB_M_Agen where AgenAktifYN = 'Y' ORDER BY AgenName ASC"
  set agen = data_cmd.execute
  ' kategori
  data_cmd.commandText = "SELECT KategoriId, KategoriNama FROM DLK_M_Kategori where KategoriAktifYN = 'Y' ORDER BY KategoriNama ASC"
  set kategori = data_cmd.execute
  ' Jenis
  data_cmd.commandText = "SELECT JenisID, JenisNama FROM DLK_M_JenisBarang where JenisAktifYN = 'Y' ORDER BY JenisNama ASC"
  set Jenis = data_cmd.execute

  ' type barang
  data_cmd.commandText = "SELECT T_ID,T_Nama FROM DLK_M_TypeBarang WHERE T_AktifYN = 'Y' ORDER BY T_Nama ASC"

  set typeBarang = data_cmd.execute

  call header("Form Alat & facility")
%>
<!--#include file="../../navbar.asp"-->

<div class="container">
  <div class="row mt-3">
    <div class="col-lg text-center">
      <h3>FORM TAMBAH ALAT & FACILITY</h3>
    </div>
  </div>
  <div class="row mb-3">
    <div class="col-lg text-center labelId">
      <h3><%= id %></h3>
    </div>
    </div>
  <form action="alat_u.asp?id=<%=id%>" method="post" onsubmit="validasiForm(this,event,'update master alat & facility','warning')">
    <input type="hidden" class="form-control" id="id" name="id" autocomplete="off" value="<%= data("Brg_id") %>" required>
    <div class="mb-3 row">
      <label for="tgl" class="col-sm-2 col-form-label offset-sm-1">Tanggal</label>
      <div class="col-sm-4">
          <input type="text" class="form-control" id="tgl" name="tgl" autocomplete="off" value="<%= data("Brg_Tanggal") %>" autocomplete="off" readonly required>
      </div>
    </div>
    <div class="mb-3 row">
      <label for="nama" class="col-sm-2 col-form-label offset-sm-1">Nama</label>
      <div class="col-sm-8">
        <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" maxlength="50" value="<%= data("Brg_nama") %>" required>
      </div>
    </div>
    <div class="mb-3 row">
      <label for="kategori" class="col-sm-2 col-form-label offset-sm-1">Kategori</label>
      <div class="col-sm-8">
        <select class="form-select" aria-label="Default select example" name="kategori" id="kategori" required>
          <option value="<%= data("KategoriID") %>"><%= data("KategoriNama") %></option>
          <% do while not kategori.eof %>
            <option value="<%= kategori("kategoriID") %>"><%= kategori("kategoriNama") %></option>
          <% 
          kategori.movenext
          loop
          %>
        </select>
      </div>
    </div>
    <div class="mb-3 row">
      <label for="jenis" class="col-sm-2 col-form-label offset-sm-1">Jenis</label>
      <div class="col-sm-8">
        <select class="form-select" aria-label="Default select example" name="jenis" id="jenis" required>
            <option value="<%= data("JenisID") %>"><%= data("jenisNama") %></option>
            <% do while not jenis.eof %>
                <option value="<%= jenis("JenisID") %>"><%= jenis("JenisNama") %></option>
            <% 
            jenis.movenext
            loop
            %>
        </select>
      </div>
    </div>
    <div class="mb-3 row">
      <label for="typebrg" class="col-sm-2 col-form-label offset-sm-1">Type Barang</label>
      <div class="col-sm-2">
        <select class="form-select" aria-label="Default select example" name="typebrg" id="typebrg" required>
          <option value="<%= data("Brg_Type") %>"><%= data("T_Nama") %></option>
          <% do while not typebarang.eof %>
          <option value="<%= typebarang("T_ID") %>"><%= typebarang("T_NAma") %></option>
          <% 
          typebarang.movenext
          loop
          %>
        </select>
      </div>
    </div>
    <div class="mb-3 row">
      <label for="minstok" class="col-sm-2 col-form-label offset-sm-1">Stok Minimal</label>
      <div class="col-sm-2">
        <input type="number" class="form-control" id="minstok" name="minstok" autocomplete="off" value="<%= data("Brg_Minstok") %>" required>
      </div>
    </div>
    <div class="row">
      <div class="col-lg text-center">
        <button type="submit" class="btn btn-primary">Update</button>
        <a href="./"><button type="button" class="btn btn-danger">kembali</button></a>
      </div>
    </div>
  </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
  call update()
end if
call footer() 
%>