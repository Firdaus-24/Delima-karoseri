<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_satuan.asp"-->
<%  
    if session("M6B") = false then 
        Response.Redirect("index.asp")
    end if

    id = trim(Request.QueryString("id"))
    ' data query
    set satuan_cmd =  Server.CreateObject ("ADODB.Command")
    satuan_cmd.ActiveConnection = mm_delima_string

    satuan_cmd.commandText = "SELECT * FROM DLK_M_SatuanBarang WHERE Sat_id = '"& id &"'"
    set satuan = satuan_cmd.execute

    call header("Form Satuan Barang") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE SATUAN BARANG</h3>
        </div>
    </div>
    <form action="sat_u.asp?id=<%= id %>" method="post" id="formsat" >
        
        <div class="row d-flex justify-content-center">
            <div class="col-lg-5 mb-3 mt-3">
                <label for="id" class="form-label">ID</label>
                <input type="text" class="form-control" id="id" name="id" value="<%= satuan("sat_id") %>" readonly required>
            </div>
        </div>
        <div class="row d-flex justify-content-center">
            <div class="col-lg-5 mb-3">
                <label for="nama" class="form-label">Nama</label>
                <input type="hidden" class="form-control" id="oldnama" name="oldnama" maxlength="20" autocomplete="off" value="<%= satuan("sat_nama") %>" required>
                <input type="text" class="form-control" id="nama" name="nama" maxlength="20" autocomplete="off" value="<%= satuan("sat_nama") %>" required>
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
    call updateSatuanBarang()
    if value = 1 then
        call alert("MASTER SATUAN BARANG", "berhasil di Update", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER SATUAN BARANG", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>