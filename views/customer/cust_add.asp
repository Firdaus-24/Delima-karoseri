<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_customer.asp"-->
<% 
    if session("M2A") = false then  
        Response.Redirect("index.asp")
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' bank
    data_cmd.commandText = "SELECT Bank_ID, Bank_Name FROM GL_M_Bank WHERE Bank_AktifYN = 'Y' ORDER BY Bank_Name ASC"
    set databank = data_cmd.execute

    call header("Form Customer")
%>
<!--#include file="../../navbar.asp"-->

<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH CUSTOMER</h3>
        </div>
    </div>
    <form action="cust_add.asp" method="post" id="formcust">
        <div class="row">
            <div class="col-sm-12 text-center p-2 rounded mb-3" style="background:#ddd;">
                <label>DETAIL CUSTOMER</label>
            </div>
        </div>
        <!-- set tanggal -->
        <input type="hidden" class="form-control" id="tgl" name="tgl" autocomplete="off" value="<%= date() %>" onfocus="(this.type = 'date')" required>

        <div class="row">
            <div class="col-lg-6 mb-3">
                <label for="nama" class="col-form-label">Nama</label>
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" autofocus maxlength="150" required>
            </div>
            <div class="col-lg-6 mb-3">
                <label for="email" class="col-form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" autocomplete="off" maxlength="150" placeholder="Ex.ptdelima@gmail.com" required>
            </div>
        </div>
        <div class="row">
           <div class="col-lg-6 mb-3">
                <label for="typet" class="col-form-label">Type Transaksi</label>
                <select class="form-select" aria-label="Default select example" name="typet" id="typet" required>
                    <option value="">Pilih</option>
                    <option value="1">CBD</option>
                    <option value="2">COD</option>
                    <option value="3">TOP</option>
                </select>
            </div>
            <div class="col-lg-6 mb-3">
                <label for="phone" class="col-form-label">Phone</label>
                <input type="tel" class="form-control" id="phone" name="phone" autocomplete="off" maxlength="15" required>
            </div>
        </div>  
        <div class="row">
            <div class="col-lg-6 mb-3">
                <label for="ptern" class="col-form-label">PayTern</label>
                <input type="number" class="form-control" id="ptern" name="ptern" autocomplete="off" required>
            </div>
            <div class="col-lg-6 mb-3">
                <label for="Alamat" class="col-form-label">Alamat</label>
                <input type="text" class="form-control" id="alamat" name="alamat" autocomplete="off" maxlength="150" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12 text-center p-2 rounded mb-3" style="background:#ddd;">
                <label>AKUN BANK</label>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-6 mb-3">
                <label for="bank" class="form-label">Bank</label>
                <select class="form-select" aria-label="Default select example" name="bank" id="bank">
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
                <input type="number" maxlength="20" class="form-control" id="norek" name="norek" autocomplete="off">
            </div>
        </div>
        <div class="row ">
            <div class="col-lg-6 mb-3">
                <label for="rekName" class="form-label">Nama Pemilik Rekening</label>
                <input type="text" class="form-control" id="rekName" name="rekName" maxlength="50" autocomplete="off">
            </div>
        </div>
        <div class="row">
            <div class="col-lg text-center">
                <button type="submit" class="btn btn-primary btn-tambahcust">Tambah</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahCust()
    if value = 1 then
        call alert("CUSTOMER", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("CUSTOMER", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>