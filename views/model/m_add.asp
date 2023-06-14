<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_model.asp"-->
<% 
  if session("MDL1A") = false then
    Response.Redirect("index.asp")
  end if
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
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
  data_cmd.commandText = "SELECT T_ID, T_Nama FROM DLK_M_TypeBarang WHERE T_AktifYN = 'Y' AND T_ID = 'T01' OR T_ID = 'T02' ORDER BY T_Nama ASC"

  set typebarang = data_cmd.execute

  call header("Form Model")
%>
<!--#include file="../../navbar.asp"-->

<div class="container">
  <div class="row mt-3 mb-3">
    <div class="col-lg text-center">
      <h3>FORM TAMBAH MODEL & SUBPART</h3>
    </div>
  </div>
  <form action="m_add.asp" method="post"  onsubmit="validasiForm(this, event, 'TAMBAH MASTER MODEL', 'warning')">
    <div class="mb-3 row">
      <label for="tgl" class="col-sm-2 col-form-label">Tanggal</label>
      <div class="col-sm-4">
        <input type="text" class="form-control" id="tgl" name="tgl" autocomplete="off" value="<%= date %>" onfocus="(this.type='date')" required>
      </div>
      <label for="agen" class="col-sm-2 col-form-label">Cabang/agen</label>
      <div class="col-sm-4">
        <select class="form-select" aria-label="Default select example" name="agen" id="agen" autofocus required>
          <option value="">Pilih</option>
          <% do while not agen.eof %>
            <option value="<%= agen("agenID") %>"><%= agen("agenName") %></option>
          <% 
          agen.movenext
          loop
          %>
        </select>
      </div>
    </div>
    <div class="mb-3 row">
      <label for="kategori" class="col-sm-2 col-form-label">Kategori</label>
      <div class="col-sm-4">
        <select class="form-select" aria-label="Default select example" name="kategori" id="kategori" required>
          <option value="">Pilih</option>
          <% do while not kategori.eof %>
              <option value="<%= kategori("kategoriID") %>"><%= kategori("kategoriNama") %></option>
          <% 
          kategori.movenext
          loop
          %>
        </select>
      </div>
      <label for="jenis" class="col-sm-2 col-form-label">Jenis</label>
      <div class="col-sm-4">
        <select class="form-select" aria-label="Default select example" name="jenis" id="jenis" required>
          <option value="">Pilih</option>
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
      <label for="nama" class="col-sm-2 col-form-label">Nama Model</label>
      <div class="col-sm-4">
        <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" maxlength="30" required>
      </div>
      <label for="typebrg" class="col-sm-2 col-form-label">Type Barang</label>
      <div class="col-sm-4">
        <select class="form-select" aria-label="Default select example" name="typebrg" id="typebrg" required>
          <option value="">Pilih</option>
          <% do while not typebarang.eof%>
          <option value="<%=typebarang("T_ID")%>"><%=typebarang("T_Nama")%></option>
          <%
          Response.flush
          typebarang.movenext
          loop
          %>
        </select>
      </div>
    </div>
    <div class="row">
      <div class="col-lg text-center">
        <button type="submit" class="btn btn-primary">Tambah</button>
        <a href="./"><button type="button" class="btn btn-danger">kembali</button></a>
      </div>
    </div>
  </form>
</div>
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahBarang()
  end if
  call footer() 
%>