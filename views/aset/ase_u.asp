<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Aset.asp"-->
<%  
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_AsetBarang WHERE AsetId = '"& id &"'"
    set Aset = data_cmd.execute

    call header("Form Aset") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE Aset BARANG</h3>
        </div>
    </div>
    <form action="jen_u.asp?id=<%= id %>" method="post" id="formjen" >
        <div class="row d-flex justify-content-center">
            <input type="hidden" class="form-control" id="id" name="id" value="<%= Aset("AsetId") %>" maxlength="30" autocomplete="off" required>
            <div class="col-lg-5 mb-3 mt-3">
                <label for="nama" class="form-label">Nama</label>
                <input type="hidden" class="form-control" id="oldnama" name="oldnama" value="<%= Aset("AsetNama") %>" maxlength="30" autocomplete="off" required>
                <input type="text" class="form-control" id="nama" name="nama" value="<%= Aset("AsetNama") %>" maxlength="30" autocomplete="off" required>
            </div>
        </div>
        <div class="row d-flex justify-content-center">
            <div class="col-lg-5 mb-3">
                <label for="keterangan" class="form-label">Keterangan</label>
                <textarea class="form-control" id="keterangan" name="keterangan" maxlength="50" style="height: 100px" required><%= Aset("AsetKeterangan") %></textarea>
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
    call updateAset()
    if value = 1 then
        call alert("MASTER Aset BARANG", "berhasil di update", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER Aset BARANG", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>