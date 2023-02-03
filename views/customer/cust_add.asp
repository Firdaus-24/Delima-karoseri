<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_customer.asp"-->
<% 
    if session("M2A") = false then  
        Response.Redirect("index.asp")
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT Cat_ID,Cat_Name FROM GL_M_CategoryItem WHERE Cat_AKtifYN = 'Y' ORDER BY Cat_Name"

    set data = data_cmd.execute

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
        <div class="mb-3 row">
            <label for="tgl" class="col-sm-2 col-form-label offset-sm-1">Tanggal</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="tgl" name="tgl" autocomplete="off" value="<%= date() %>" onfocus="(this.type = 'date')" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="nama" class="col-sm-2 col-form-label offset-sm-1">Nama</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" autofocus maxlength="150" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="email" class="col-sm-2 col-form-label offset-sm-1">Email</label>
            <div class="col-sm-8">
                <input type="email" class="form-control" id="email" name="email" autocomplete="off" maxlength="150" placeholder="Ex.ptdelima@gmail.com" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="Alamat" class="col-sm-2 col-form-label offset-sm-1">Alamat</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="alamat" name="alamat" autocomplete="off" maxlength="150" required>
            </div>
        </div>  
        <div class="mb-3 row">
            <label for="phone1" class="col-sm-2 col-form-label offset-sm-1">Phone 1</label>
            <div class="col-sm-8">
                <input type="tel" class="form-control" id="phone1" name="phone1" autocomplete="off" maxlength="15" placeholder="Ex.0856-20018377" pattern="[0-9]{4}-[0-9]{8}" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="phone2" class="col-sm-2 col-form-label offset-sm-1">Phone 2</label>
            <div class="col-sm-8">
                <input type="tel" class="form-control" id="phone2" name="phone2" maxlength="15" autocomplete="off">
            </div>
        </div>
        <div class="mb-3 row">
            <label for="kdakun" class="col-sm-2 col-form-label offset-sm-1">Kode Akun</label>
            <div class="col-sm-8">
                <select class="form-select" aria-label="Default select example" id="kdakun" name="kdakun" required>
                    <option value="">Pilih</option>
                    <% do while not data.eof %>
                    <option value="<%= data("cat_id") %>"><%= data("cat_Name") %></option>
                    <% 
                    data.movenext
                    loop
                    %>
                </select>
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