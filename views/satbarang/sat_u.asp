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
    <div class="row position-relative text-center">
        <div class="col-sm-3 border border-primary rounded position-absolute top-0 start-0 translate-middle offset-sm-2" style="font-weight:600;background-color:#fff;padding:5px">
            <label>SATUAN BARANG PT.DELIMA KAROSERI</label>
        </div>
        <div class="col-sm-1 border border-primary rounded position-absolute top-0 end-0 translate-middle" style="font-weight:600;background-color:#fff;">
            <label>ID : <%= satuan("sat_id") %></label>
        </div>
    </div>
    <form action="sat_u.asp?id=<%= id %>" method="post" id="formsat" class="border border-primary rounded p-3" style="background-color:rgba(137, 196, 244, 0.2);">
        
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