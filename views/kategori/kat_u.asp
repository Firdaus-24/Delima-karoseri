<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_kategori.asp"-->
<%  
    if session("M4B") = false then 
        Response.Redirect("index.asp")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Kategori WHERE KategoriId = '"& id &"'"
    set kategori = data_cmd.execute

    call header("Form Kategori") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE KATEGORI</h3>
        </div>
    </div>
    <form action="kat_u.asp?id=<%= id %>" method="post" id="formkat" >
        <div class="row d-flex justify-content-center">
            <div class="col-lg-5 mb-3 mt-3">
                <label for="id" class="form-label">ID</label>
                <input type="text" class="form-control" id="id" name="id" value="<%= kategori("kategoriId") %>" maxlength="30" autocomplete="off" readonly required>
            </div>
        </div>
        <div class="row d-flex justify-content-center">
            <div class="col-lg-5 mb-3">
                <label for="nama" class="form-label">Nama</label>
                <input type="hidden" class="form-control" id="oldnama" name="oldnama" value="<%= kategori("kategoriNama") %>" maxlength="30" autocomplete="off" required>
                <input type="text" class="form-control" id="nama" name="nama" value="<%= kategori("kategoriNama") %>" maxlength="30" autocomplete="off" required>
            </div>
        </div>
        <div class="row d-flex justify-content-center">
            <div class="col-lg-5 mb-3">
                <label for="keterangan" class="form-label">Keterangan</label>
                <textarea class="form-control" id="keterangan" name="keterangan" maxlength="50" style="height: 100px" required><%= kategori("kategoriKeterangan") %></textarea>
            </div>
        </div>
        <div class="row text-center">
            <div class="col-lg">
                <button type="submit" class="btn btn-primary">Update</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateKategori()
    if value = 1 then
        call alert("MASTER KATEGORI", "berhasil di update", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER KATEGORI", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>