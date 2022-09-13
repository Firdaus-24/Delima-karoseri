<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_barang.asp"-->
<% 
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

    call header("Form Barang")
%>
<!--#include file="../../navbar.asp"-->

<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH BARANG</h3>
        </div>
    </div>
    <form action="bg_add.asp" method="post" id="formBarang">
        <div class="mb-3 row">
            <label for="tgl" class="col-sm-2 col-form-label offset-sm-1">Tanggal</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="tgl" name="tgl" autocomplete="off" value="<%= date %>" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="agen" class="col-sm-2 col-form-label offset-sm-1">Cabang/agen</label>
            <div class="col-sm-8">
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
            <label for="nama" class="col-sm-2 col-form-label offset-sm-1">Nama</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" maxlength="30" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="kategori" class="col-sm-2 col-form-label offset-sm-1">Kategori</label>
            <div class="col-sm-8">
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
        </div>
        <div class="mb-3 row">
            <label for="jenis" class="col-sm-2 col-form-label offset-sm-1">Jenis</label>
            <div class="col-sm-8">
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
            <label for="stok" class="col-sm-2 col-form-label offset-sm-1">Stok</label>
            <div class="col-sm-8">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="stok" id="sY" value="Y">
                    <label class="form-check-label" for="sY">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="stok" id="sN" value="N">
                    <label class="form-check-label" for="sN">No</label>
                </div>
            </div>
        </div>  
        <div class="mb-3 row">
            <label for="jual" class="col-sm-2 col-form-label offset-sm-1">Jual</label>
            <div class="col-sm-8">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="jual" id="jY" value="Y">
                    <label class="form-check-label" for="jY">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="jual" id="jN" value="N">
                    <label class="form-check-label" for="jN">No</label>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg text-center">
                <button type="submit" class="btn btn-primary btn-tambahBarang">Tambah</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahBarang()
    if value = 1 then
        call alert("BARANG", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("BARANG", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>