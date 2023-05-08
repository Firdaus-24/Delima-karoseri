<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_kategori.asp"-->
<%  
    if session("M4A") = false then 
        Response.Redirect("index.asp")
    end if
    
    call header("Form Kategori") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH KATEGORI</h3>
        </div>
    </div>
    <form action="kat_add.asp" method="post" id="formkat" >
        <div class="row d-flex justify-content-center">
            <div class="col-lg-5 mb-3 mt-3">
                <label for="nama" class="form-label">Nama</label>
                <input type="text" class="form-control" id="nama" name="nama" maxlength="30" autocomplete="off" required>
            </div>
        </div>
        <div class="row d-flex justify-content-center">
            <div class="col-lg-5 mb-3">
                <label for="keterangan" class="form-label">Keterangan</label>
                <textarea class="form-control" id="keterangan" name="keterangan" maxlength="50" style="height: 100px"></textarea>
            </div>
        </div>
        <div class="row text-center">
            <div class="col-lg">
                <button type="submit" class="btn btn-primary">Tambah</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahKategori()
    if value = 1 then
        call alert("MASTER KATEGORI", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER KATEGORI", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>