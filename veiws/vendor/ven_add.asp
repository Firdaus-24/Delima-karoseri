<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_vendor.asp"-->
<% 
    set cabang_cmd =  Server.CreateObject ("ADODB.Command")
    cabang_cmd.ActiveConnection = mm_delima_string

    cabang_cmd.commandText = "SELECT * FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set cabang = cabang_cmd.execute

    call header("tambah vendor")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH VENDOR</h3>
        </div>
    </div>
    <div class="row d-flex justify-content-center">
        <div class="col-lg-10">
            <form action="ven_add.asp" method="post" id="formVendor">
                <div class="row mb-3">
                    <div class="col-lg-6">
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
                    <div class="col-lg-6">
                        <label for="nama" class="form-label">Nama</label>
                        <input type="text" class="form-control" id="nama" name="nama" maxlength="30" autocomplete="off" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-lg-6">
                        <label for="alamat" class="form-label">Alamat</label>
                        <input type="text" class="form-control" id="alamat" name="alamat" maxlength="50" autocomplete="off" required>
                    </div>
                    <div class="col-lg-6">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="phone" name="phone" autocomplete="off" pattern="[0-9]{12}" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" maxlength="50" autocomplete="off">
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg text-center">
                        <button type="submit" class="btn btn-primary">Tambah</button>
                        <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
                    </div>
                </div>                
            </form>
        </div>
    </div>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahVendor()
    if value = 1 then
        call alert("MASTER VENDOR", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER VENDOR", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>