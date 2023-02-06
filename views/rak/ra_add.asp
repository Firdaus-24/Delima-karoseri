<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_rak.asp"-->
<% 
    if session("M5A") = false then 
        Response.Redirect("../index.asp")
    end if

    ' query cabang
    set cabang_cmd =  Server.CreateObject ("ADODB.Command")
    cabang_cmd.ActiveConnection = mm_delima_string

    cabang_cmd.commandText = "SELECT * FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set cabang = cabang_cmd.execute

    call header("Form Rak Inventory")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH RAK INVENTORY</h3>
        </div>
    </div>
    <form action="ra_add.asp" method="post" id="formrak">
        <div class="row">
            <div class="col-lg-5 mb-3">
                <label for="cabang" class="form-label">Pilih Cabang</label>
                <select class="form-select" aria-label="Default select example" name="cabang" id="cabang" required>
                    <option value="">Pilih</option>
                    <% do while not cabang.eof %>
                        <option value="<%= cabang("agenID") %>"><%= cabang("agenName") %></option>
                    <% 
                    cabang.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-5 mb-3">
                <label for="nama" class="form-label">Nama</label>
                <input type="text" class="form-control" id="nama" name="nama" maxlength="20" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-lg mb-3">
                <label for="keterangan" class="form-label">Keterangan</label>
                <textarea class="form-control" id="keterangan" name="keterangan" maxlength="50" style="height: 100px" required></textarea>
            </div>
        </div>
        <div class="row">
            <div class="col-lg">
                <button type="submit" class="btn btn-primary">Tambah</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahRak()
    if value = 1 then
        call alert("MASTER RAK INVENTORY", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER RAK INVENTORY", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>