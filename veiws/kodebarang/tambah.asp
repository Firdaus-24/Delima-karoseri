<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_kdbarang.asp"-->
<% 
call header("kodebarangAdd")

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH KODE BARANG</h3>
        </div>
    </div>
    <div class="row d-flex justify-content-center">
        <div class="col-lg-10">
            <form action="tambah.asp" method="post" id="formKdBarang">
                <div class="mb-3">
                    <label for="nama" class="form-label">Kode Type</label>
                    <input type="text" class="form-control" id="nama" name="nama" maxlength="20" autocomplete="off" required>
                </div>
                <div class="mb-3">
                    <label for="nama" class="form-label">Kode Deskripsi</label>
                    <textarea class="form-control" id="nama" name="deskripsi" maxlength="30" style="height: 100px" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary" name="tambahKd" id="tambahKd" value="send">Tambah</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </form>
        </div>
    </div>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahKdBarang()
    if value = 1 then
        call alert("KODE BARANG", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("KODE BARANG", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>