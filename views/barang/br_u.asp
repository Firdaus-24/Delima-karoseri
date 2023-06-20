<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_barang.asp"-->
<% 
     if session("M1B") = false then
        Response.Redirect("index.asp")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    ' get data by id
    data_cmd.commandText = "SELECT DLK_M_Barang.*, DLK_M_typeBarang.T_Nama, DLK_M_TypeBarang.T_Nama, DLK_M_kategori.KategoriNama, DLK_M_JenisBarang.jenisNama, DLK_M_TypeBarang.T_Nama, DLK_M_kategori.KategoriID, DLK_M_JenisBarang.jenisID FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_TYpeBarang ON DLK_M_Barang.Brg_Type = DLK_M_TypeBarang.T_ID LEFT OUTER JOIN DLK_M_KAtegori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.jenisID = DLK_M_JenisBarang.JenisID WHERE Brg_ID = '"& id &"' AND Brg_AktifYN = 'Y'"
    set barang = data_cmd.execute

    ' kategori
    data_cmd.commandText = "SELECT KategoriId, KategoriNama FROM DLK_M_Kategori where KategoriAktifYN = 'Y' ORDER BY KategoriNama ASC"
    set pkategori = data_cmd.execute
    ' Jenis
    data_cmd.commandText = "SELECT JenisID, JenisNama FROM DLK_M_JenisBarang where JenisAktifYN = 'Y' ORDER BY JenisNama ASC"
    set pJenis = data_cmd.execute

    ' type barang
    data_cmd.commandText = "SELECT T_ID, T_Nama FROM DLK_M_TypeBarang WHERE T_AktifYN = 'Y' AND T_ID <> 'T01' AND T_ID <> 'T02' AND T_ID <> 'T05' AND T_ID <> 'T06' ORDER BY T_Nama ASC"

    set typebarang = data_cmd.execute
    
    call header("Form Barang")
%>
<!--#include file="../../navbar.asp"-->

<div class="container">
    <div class="row mt-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE BARANG</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <form action="br_u.asp?id=<%= id %>" method="post" id="formBarang">
        <input type="hidden" class="form-control" id="id" name="id" autocomplete="off" value="<%= barang("Brg_id") %>" required>
        <div class="mb-3 row">
            <label for="tgl" class="col-sm-2 col-form-label offset-sm-1">Tanggal</label>
            <div class="col-sm-5">
                <input type="text" class="form-control" id="tgl" name="tgl" value="<%= barang("Brg_Tanggal") %>" autocomplete="off" readonly required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="nama" class="col-sm-2 col-form-label offset-sm-1">Nama</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" autofocus maxlength="50" value="<%= barang("Brg_nama") %>" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="kategori" class="col-sm-2 col-form-label offset-sm-1">Kategori</label>
            <div class="col-sm-8">
                <select class="form-select" aria-label="Default select example" name="kategori" id="kategori" required> 
                    <option value="<%= barang("KategoriID") %>"><%= barang("KategoriNama") %></option>
                    <% 
                    do while not pkategori.eof %>
                        <option value="<%= pkategori("kategoriID") %>"><%= pkategori("kategoriNama") %></option>
                    <% 
                    pkategori.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="jenis" class="col-sm-2 col-form-label offset-sm-1">Jenis</label>
            <div class="col-sm-8">
                <select class="form-select" aria-label="Default select example" name="jenis" id="jenis" required>
                    <option value="<%= barang("JenisID") %>"><%= barang("jenisNama") %></option>
                    <% do while not pjenis.eof %>
                        <option value="<%= pjenis("JenisID") %>"><%= pjenis("JenisNama") %></option>
                    <% 
                    pjenis.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="typebrg" class="col-sm-2 col-form-label offset-sm-1">Type Barang</label>
            <div class="col-sm-2">
                <select class="form-select" aria-label="Default select example" name="typebrg" id="typebrg" required>
                    <option value="<%= barang("Brg_Type") %>">
                        <%= barang("T_Nama") %>
                    </option>
                    <% do while not typebarang.eof %>
                    <option value="<%= typebarang("T_ID") %>"><%= typebarang("T_Nama") %></option>
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
                <input type="number" class="form-control" id="minstok" name="minstok" autocomplete="off" value="<%= barang("Brg_Minstok") %>" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="stok" class="col-sm-2 col-form-label offset-sm-1">Stok</label>
            <div class="col-sm-8">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="stok" id="sY" value="Y" <% if barang("Brg_stokYN") = "Y" then %>checked <% end if %>>
                    <label class="form-check-label" for="sY" >Yes</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="stok" id="sN" value="N" <% if barang("Brg_stokYN") = "N" then %>checked <% end if %>>
                    <label class="form-check-label" for="sN" >No</label>
                </div>
            </div>
        </div>  
        <div class="mb-3 row">
            <label for="jual" class="col-sm-2 col-form-label offset-sm-1">Jual</label>
            <div class="col-sm-8">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="jual" id="jY" value="Y" <% if barang("Brg_jualYN") = "Y" then %>checked <% end if %>>
                    <label class="form-check-label" for="jY">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="jual" id="jN" value="N" <% if barang("Brg_jualYN") = "N" then %>checked <% end if %>>
                    <label class="form-check-label" for="jN">No</label>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg text-center">
                <button type="submit" class="btn btn-primary btn-tambahBarang">Update</button>
                <a href="./"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateBarang()
    if value = 1 then
        call alert("BARANG", "berhasil di update", "success","index.asp") 
    elseif value = 2 then
        call alert("BARANG", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>