<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_barang.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    ' get data by id
    data_cmd.commandText = "SELECT * FROM DLK_M_Barang WHERE Brg_ID = '"& id &"' AND Brg_AktifYN = 'Y'"
    set barang = data_cmd.execute
    ' cabang
    data_cmd.commandText = "SELECT AgenID, AgenNAme FROM GLB_M_Agen where AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set agen = data_cmd.execute
    ' vendor
    data_cmd.commandText = "SELECT Ven_ID, Ven_Nama FROM DLK_M_Vendor where Ven_AktifYN = 'Y' ORDER BY Ven_Nama ASC"
    set pvendor = data_cmd.execute
    ' kategori
    data_cmd.commandText = "SELECT KategoriId, KategoriNama FROM DLK_M_Kategori where KategoriAktifYN = 'Y' ORDER BY KategoriNama ASC"
    set pkategori = data_cmd.execute
    ' Jenis
    data_cmd.commandText = "SELECT JenisID, JenisNama FROM DLK_M_JenisBarang where JenisAktifYN = 'Y' ORDER BY JenisNama ASC"
    set pJenis = data_cmd.execute


    
call header("Form Barang")
%>
<!--#include file="../../navbar.asp"-->

<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE BARANG</h3>
        </div>
    </div>
    <form action="br_u.asp?id=<%= id %>" method="post" id="formBarang">
        <input type="hidden" class="form-control" 1id="id" name="id" autocomplete="off" value="<%= barang("Brg_id") %>" required>
        <div class="mb-3 row">
            <label for="nama" class="col-sm-2 col-form-label offset-sm-1">Nama</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" autofocus maxlength="30" value="<%= barang("Brg_nama") %>" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="kategori" class="col-sm-2 col-form-label offset-sm-1">Kategori</label>
            <div class="col-sm-8">
                <select class="form-select" aria-label="Default select example" name="kategori" id="kategori" required> 
                    <option value="<%= barang("KategoriID") %>"><% call getKategori(barang("KategoriID")) %></option>
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
                    <option value="<%= barang("JenisID") %>"><% call getJenis(barang("JenisID")) %></option>
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
            <label for="tgl" class="col-sm-2 col-form-label offset-sm-1">Tanggal</label>
            <div class="col-sm-5">
                <input type="text" class="form-control" id="tgl" name="tgl" value="<%= barang("Brg_Tanggal") %>" autocomplete="off" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="vendor" class="col-sm-2 col-form-label offset-sm-1">Vendor</label>
            <div class="col-sm-8">
                <select class="form-select" aria-label="Default select example" name="vendor" id="vendor" required>
                    <option value="<%= barang("Brg_VendorID") %>"><% call getVendor(barang("Brg_VendorID")) %></option>
                    <% do while not pvendor.eof %>
                        <option value="<%= pvendor("ven_ID") %>"><%= pvendor("Ven_Nama") %></option>
                    <% 
                    pvendor.movenext
                    loop
                    %>
                </select>
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
        <div class="mb-3 row">
            <label for="harga" class="col-sm-2 col-form-label offset-sm-1">Harga</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="harga" name="harga" autocomplete="off" value="<%= barang("Brg_Harga") %>" required>
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