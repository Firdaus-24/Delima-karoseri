<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_vendor.asp"-->
<% 
    id = Request.QueryString("id")

    ' cabang
    set cabang_cmd =  Server.CreateObject ("ADODB.Command")
    cabang_cmd.ActiveConnection = mm_delima_string

    cabang_cmd.commandText = "SELECT * FROM GLB_M_Agen WHERE AgenAktifYN = 'Y'"
    set cabang = cabang_cmd.execute

    ' data vendor
    cabang_cmd.commandText = "SELECT * FROM DLK_M_Vendor WHERE Ven_ID = '"& id &"'"
    set vendor = cabang_cmd.execute

    ' data cabangvendor
    cabang_cmd.commandText = "SELECT AgenId, AgenName FROM GLB_M_Agen WHERE AgenID = '"& left(id,3) &"'"
    set cabid = cabang_cmd.execute

    call header("update vendor")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE VENDOR</h3>
        </div>
    </div>
    <div class="row d-flex justify-content-center">
        <div class="col-lg-10">
            <form action="vn_u.asp?id=<%= id %>" method="post" id="formVendor">
                <!-- id vendor -->
                <input type="hidden" class="form-control" id="id" name="id" autocomplete="off" value="<%= vendor("ven_id") %>" required>
                <div class="row mb-3">
                    <div class="col-lg-6">
                        <label for="cabang" class="form-label">Pilih Cabang</label>
                        <select class="form-select" aria-label="Default select example" name="cabang" id="cabang" required>
                            <option value="<%= cabid("AgenId") %>"><%= cabId("agenName") %></option>
                            <% do while not cabang.eof %>
                                <option value="<%= cabang("agenID") %>"><%= cabang("agenName") %></option>
                            <% 
                            cabang.movenext
                            loop
                            %>
                        </select>
                    </div>
                    <div class="col-lg-6">
                        <label for="nama" class="form-label">Nama</label>
                        <input type="hidden" class="form-control" id="oldnama" name="oldnama" maxlength="30" autocomplete="off" value="<%= vendor("ven_nama") %>" required>
                        <input type="text" class="form-control" id="nama" name="nama" maxlength="30" autocomplete="off" value="<%= vendor("ven_nama") %>" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-lg-6">
                        <label for="alamat" class="form-label">Alamat</label>
                        <input type="text" class="form-control" id="alamat" name="alamat" maxlength="50" autocomplete="off" value="<%= vendor("ven_Alamat") %>" required>
                    </div>
                    <div class="col-lg-6">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="phone" name="phone" autocomplete="off" pattern="[0-9]{12}" value="<%= vendor("ven_Phone") %>" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg text-center">
                        <button type="submit" class="btn btn-primary">Update</button>
                        <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
                    </div>
                </div>                
            </form>
        </div>
    </div>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateVendor()
    if value = 1 then
        call alert("MASTER VENDOR", "berhasil di update", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER VENDOR", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>