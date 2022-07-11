<!--#include file="../../init.asp"-->
<% 
    call header("kodebarangUpdate")
 %>
<!--#include file="../../navbar.asp"-->
<% 
    id = Request.QueryString("id")

    if id <> "" then
        set data =  Server.CreateObject ("ADODB.Command")
        data.ActiveConnection =  mm_delima_string

        data.commandText = "SELECT * FROM DLK_M_KodeBarang WHERE Kode_ID = '"& id &"'"
        set kdbarang = data.execute

%>
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM RUBAH KODE BARANG</h3>
        </div>
    </div>
    <div class="row d-flex justify-content-center">
        <div class="col-lg-10">
            <form action="update.asp" method="post">
                <input type="hidden" class="form-control" id="id" name="id" value="<%= kdbarang("Kode_ID") %> ">
                <div class="mb-3">
                    <label for="nama" class="form-label">Kode Type</label>
                    <input type="text" class="form-control" id="nama" name="nama" value="<%= kdbarang("Kode_Nama") %>" maxlength="20" autocomplete="off" required>
                    <input type="hidden" class="form-control" id="oldnama" name="oldnama" value="<%= kdbarang("Kode_Nama") %>" maxlength="20">
                </div>
                <div class="mb-3">
                    <label for="nama" class="form-label">Kode Deskripsi</label>
                    <textarea class="form-control" id="nama" name="deskripsi" maxlength="30" style="height: 100px" required><%= kdbarang("kode_keterangan")%></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Update</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </form>
        </div>
    </div>
</div>
<% 
    else
        if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
            call updateKdBarang()
            if value = 1 then
                call alert("KODE BARANG", "berhasil di rubah", "success","index.asp") 
            elseif value = 2 then
                call alert("KODE BARANG", "tidak terdaftar", "warning","index.asp")
            else
                value = 0
            end if
        end if
    end if
call footer() 
%>