<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_customer.asp"-->
<% 
    if session("M2B") = false then  
        Response.Redirect("index.asp")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_M_Customer.*, GL_M_CategoryItem.Cat_Name FROM DLK_M_Customer LEFT OUTER JOIN GL_M_CategoryItem ON DLK_M_Customer.custKodeAkun = GL_M_CategoryItem.Cat_ID WHERE CustID = '"& id &"' AND custAktifYN = 'Y'"

    set data = data_cmd.execute

    data_cmd.commandText = "SELECT Cat_ID,Cat_Name FROM GL_M_CategoryItem WHERE Cat_AKtifYN = 'Y' ORDER BY Cat_Name"

    set dataakun = data_cmd.execute

    call header("Form Customer")
%>
<!--#include file="../../navbar.asp"-->

<div class="container">
    <div class="row mt-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE CUSTOMER</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <form action="cust_u.asp?id=<%= id %>" method="post" id="formcust">
        <input type="hidden" class="form-control" id="id" name="id" autocomplete="off" value="<%= data("custid") %>">
        <div class="mb-3 row">
            <label for="tgl" class="col-sm-2 col-form-label offset-sm-1">Tanggal</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="tgl" name="tgl" autocomplete="off" value="<%= Cdate(data("custTgl")) %>" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="nama" class="col-sm-2 col-form-label offset-sm-1">Nama</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" maxlength="150" value="<%= data("custNama") %>" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="email" class="col-sm-2 col-form-label offset-sm-1">Email</label>
            <div class="col-sm-8">
                <input type="email" class="form-control" id="email" name="email" autocomplete="off" maxlength="150" placeholder="Ex.ptdelima@gmail.com" value="<%= data("custEmail") %>" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="Alamat" class="col-sm-2 col-form-label offset-sm-1">Alamat</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="alamat" name="alamat" autocomplete="off" maxlength="150" value="<%= data("custAlamat") %>" required>
            </div>
        </div>  
        <div class="mb-3 row">
            <label for="phone1" class="col-sm-2 col-form-label offset-sm-1">Phone 1</label>
            <div class="col-sm-8">
                <input type="tel" class="form-control" id="phone1" name="phone1" autocomplete="off" maxlength="15" placeholder="Ex.0856-20018377" pattern="[0-9]{4}-[0-9]{8}" value="<%= data("custPhone1") %>" required>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="phone2" class="col-sm-2 col-form-label offset-sm-1">Phone 2</label>
            <div class="col-sm-8">
                <input type="tel" class="form-control" id="phone2" name="phone2" maxlength="15" value="<%= data("custPhone2") %>" autocomplete="off">
            </div>
        </div>
        <div class="mb-3 row">
            <label for="kdakun" class="col-sm-2 col-form-label offset-sm-1">Kode Akun</label>
            <div class="col-sm-8">
                <select class="form-select" aria-label="Default select example" id="kdakun" name="kdakun" required>
                    <option value="<%= data("custkodeakun") %>"><%= data("cat_name") %></option>
                    <% do while not dataakun.eof %>
                    <option value="<%= dataakun("cat_id") %>"><%= dataakun("cat_Name") %></option>
                    <% 
                    dataakun.movenext
                    loop
                    %>
                </select>
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
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateCust()
    if value = 1 then
        call alert("CUSTOMER", "berhasil di update", "success","index.asp") 
    elseif value = 2 then
        call alert("CUSTOMER", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>