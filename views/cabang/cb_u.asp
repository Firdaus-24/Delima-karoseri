<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_cabang.asp"-->
<% 
    if session("HR4B") = false then
        Response.Redirect("index.asp")
    end if
    id = Request.QueryString("id")

    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_Delima_String

    data.commandText = "SELECT * FROM GLB_M_Agen WHERE AgenID = '"& id &"'"
    set cabang = data.execute

    call header("Form Update Cabang")

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE CABANG</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row d-flex justify-content-center">
        <div class="col-lg-10">
            <form action="cb_u.asp?id=<%= id %>" method="post" id="formcabang">
                <div class="row mb-3">
                    <div class="col-lg-9">
                        <input type="hidden" class="form-control" id="id" name="id" autocomplete="off" placeholder="Nama Cabang" value="<%= cabang("agenID") %>" required>

                        <label for="nama" class="form-label">Nama Cabang</label>
                        <input type="text" class="form-control" id="nama" name="nama" maxlength="100" autocomplete="off" placeholder="Nama Cabang" value="<%= cabang("agenname") %>" required>
                    </div>
                    <div class="col-lg-3">
                        <label for="kdpos" class="form-label">Kode Pos</label>
                        <input type="text" class="form-control" id="kdpos" name="kdpos" maxlength="20" autocomplete="off" placeholder="Cari Nama Kota" value="<%= cabang("agenKodepos") %>" required>
                    </div>
                </div>
                <!-- get ajax kodepos-->
                <div class="row">
                    <div class="col-lg-12 showkdpos"></div>
                    <div class="row loaderKdpos">
                        <div class="col-lg d-flex justify-content-center">
                            <img src="<%= url %>/public/img/loader.gif" width="40" height="40">
                        </div>
                    </div>
                </div>
                <!-- end get ajax -->
                <div class="mb-3">
                    <label for="alamat" class="form-label">Alamat</label>
                    <textarea class="form-control" id="alamat" name="alamat" maxlength="150" style="height: 100px" placeholder="Alamat" required><%= cabang("AgenAlamat") %></textarea>
                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <label for="contact" class="form-label">Contact Person</label>
                        <input type="text" class="form-control" id="contact" name="contact" maxlength="50" autocomplete="off" placeholder="Agen Contact" value="<%= cabang("agenContactPerson") %>" required>
                    </div>
                    <div class="col-lg-3">
                        <label for="phone1" class="form-label">Phone 1</label>
                        <input type="tel" class="form-control" id="phone1" name="phone1" pattern="[0-9]{12}" autocomplete="off" value="<%= cabang("agenPhone1") %>" required>
                    </div>
                    <div class="col-lg-3">
                        <label for="phone2" class="form-label">Phone 2</label>
                        <input type="tel" class="form-control" id="phone2" name="phone2" value="<%= cabang("agenPhone2") %>" pattern="[0-9]{12}" autocomplete="off">
                    </div>
                </div>
                <div class="col-lg-6 mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" maxlength="50" autocomplete="off" placeholder="Email" value="<%= cabang("agenEmail") %>" required>
                </div>
                <button type="submit" class="btn btn-primary">Update</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </form>
        </div>
    </div>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateCabang()
    if value = 1 then
        call alert("CABANG", "berhasil di ubah", "success","index.asp") 
    elseif value = 2 then
        call alert("CABANG", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>