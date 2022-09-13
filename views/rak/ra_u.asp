<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_rak.asp"-->
<% 
    id = Request.QueryString("id")
    ' query cabang
    set cabang_cmd =  Server.CreateObject ("ADODB.Command")
    cabang_cmd.ActiveConnection = mm_delima_string

    cabang_cmd.commandText = "SELECT * FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set cabang = cabang_cmd.execute

    ' query data cabang
    cabang_cmd.commandText = "SELECT AgenID, AgenName FROM GLB_M_Agen WHERE AgenID = '"& left(id,3) &"'"
    set idcabang = cabang_cmd.execute

    ' query data
    cabang_cmd.commandText = "SELECT * FROM DLK_M_Rak WHERE Rak_ID = '"& id &"'"
    set rak = cabang_cmd.execute

    call header("Form Rak Inventory")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE RAK INVENTORY</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <form action="ra_u.asp?id=<%= id %>" method="post" id="formrak">
        <!-- id rak -->
        <input type="hidden" class="form-control" id="id" name="id" value="<%= rak("Rak_id") %>" required>
        <div class="row">
            <div class="col-lg-5 mb-3">
                <label for="cabang" class="form-label">Pilih Cabang</label>
                <select class="form-select" aria-label="Default select example" name="cabang" id="cabang" required>
                    <option value="<%= idcabang("AgenID") %>"><%= idcabang("agenName") %></option>
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
                <input type="hidden" class="form-control" id="oldnama" name="oldnama" maxlength="20" autocomplete="off" value="<%= rak("Rak_Nama") %>" required>
                <input type="text" class="form-control" id="nama" name="nama" maxlength="20" autocomplete="off" value="<%= rak("Rak_Nama") %>" required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="updatetime" class="form-label">Update Time</label>
                <input type="text" class="form-control" id="updatetime" name="updatetime" value="<%= rak("Rak_UpdateTime") %>" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="row">
            <div class="col-lg mb-3">
                <label for="keterangan" class="form-label">Keterangan</label>
                <textarea class="form-control" id="keterangan" name="keterangan" maxlength="50" style="height: 100px" required><%= rak("Rak_Keterangan") %></textarea>
            </div>
        </div>
        <div class="row">
            <div class="col-lg">
                <button type="submit" class="btn btn-primary">Update</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateRak()
    if value = 1 then
        call alert("MASTER RAK INVENTORY", "berhasil di update", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER RAK INVENTORY", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>