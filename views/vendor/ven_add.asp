<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_vendor.asp"-->
<% 
    set cabang_cmd =  Server.CreateObject ("ADODB.Command")
    cabang_cmd.ActiveConnection = mm_delima_string
    ' cabang / agen
    cabang_cmd.commandText = "SELECT * FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set cabang = cabang_cmd.execute
    ' kode akun
    cabang_cmd.commandText = "SELECT * FROM GL_M_CategoryItem WHERE cat_AktifYN = 'Y' ORDER BY cat_Name ASC"
    set dataakun = cabang_cmd.execute
    ' bank
    cabang_cmd.commandText = "SELECT Bank_ID, Bank_Name FROM GL_M_Bank WHERE Bank_AktifYN = 'Y' ORDER BY Bank_Name ASC"
    set databank = cabang_cmd.execute

    call header("Tambah Vendor")
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
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" maxlength="50" autocomplete="off">
                    </div>
                    <div class="col-lg-6">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="phone" name="phone" autocomplete="off" pattern="[0-9]{12}" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="kdakun" class="form-label">Kode Akun</label>
                        <select class="form-select" aria-label="Default select example" id="kdakun" name="kdakun" required>
                            <option value="">Pilih</option>
                            <% do while not dataakun.eof %>
                                <option value="<%= dataakun("Cat_ID") %>"><%= dataakun("cat_Name") %></option>
                            <% 
                            dataakun.movenext
                            loop
                            %>
                        </select>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="typet" class="form-label">Type Transaksi</label>
                        <select class="form-select" aria-label="Default select example" name="typet" id="typet" required>
                            <option value="">Pilih</option>
                            <option value="1">CBD</option>
                            <option value="2">COD</option>
                            <option value="3">TOP</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="bank" class="form-label">Bank</label>
                        <select class="form-select" aria-label="Default select example" name="bank" id="bank" required>
                            <option value="">Pilih</option>
                            <% do while not databank.eof %>
                            <option value="<%= databank("bank_ID") %>"><%= databank("Bank_Name") %></option>
                            <% 
                            databank.movenext
                            loop
                            %>
                        </select>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="norek" class="form-label">No.Rekening</label>
                        <input type="text" maxlength="20" class="form-control" id="norek" name="norek" autocomplete="off" required>
                    </div>
                </div>
                <div class="row ">
                    <div class="col-lg-6 mb-3">
                        <label for="alamat" class="form-label">Alamat</label>
                        <input type="text" class="form-control" id="alamat" name="alamat" maxlength="50" autocomplete="off" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg text-center">
                        <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
                        <button type="submit" class="btn btn-primary">Tambah</button>
                    </div>
                </div>                
            </form>
        </div>
    </div>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahVendor()
end if
call footer() 
%>