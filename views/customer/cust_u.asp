<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_customer.asp"-->
<% 
    if session("M2B") = false then  
        Response.Redirect("index.asp")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_M_Customer.*, GL_M_ChartAccount.CA_Name, ISNULL(dbo.GL_M_Bank.Bank_Name,'') as bank FROM DLK_M_Customer LEFT OUTER JOIN GL_M_ChartAccount ON DLK_M_Customer.custKodeAkun = GL_M_ChartAccount.CA_ID LEFT OUTER JOIN dbo.GL_M_Bank ON dbo.DLK_M_Customer.custBankID = dbo.GL_M_Bank.Bank_ID WHERE CustID = '"& id &"' AND custAktifYN = 'Y'"

    set data = data_cmd.execute

    data_cmd.commandText = "SELECT GL_M_chartAccount.CA_ID, GL_M_chartAccount.CA_Name FROM GL_M_chartAccount WHERE CA_AktifYN = 'Y' ORDER BY CA_id ASC"

    set dataakun = data_cmd.execute

    ' bank
    data_cmd.commandText = "SELECT Bank_ID, Bank_Name FROM GL_M_Bank WHERE Bank_AktifYN = 'Y' ORDER BY Bank_Name ASC"
    set databank = data_cmd.execute


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
        <div class="row">
            <div class="col-sm-12 text-center p-2 rounded mb-3" style="background:#ddd;">
                <label>DETAIL CUSTOMER</label>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-6 mb-3">
                <label for="nama" class="col-form-label">Nama</label>
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" autofocus maxlength="150" value="<%= data("custNama") %>" required>
            </div>
            <div class="col-lg-6 mb-3">
                <label for="email" class="col-form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" autocomplete="off" maxlength="150" value="<%= data("custEmail") %>" placeholder="Ex.ptdelima@gmail.com" required>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-6 mb-3">
                <label for="Alamat" class="col-form-label">Alamat</label>
                <input type="text" class="form-control" id="alamat" name="alamat" autocomplete="off" maxlength="150" value="<%= data("custAlamat") %>" required>
            </div>
            <div class="col-lg-6 mb-3">
                <label for="phone" class="col-form-label">Phone</label>
                <input type="tel" class="form-control" id="phone" name="phone" autocomplete="off" maxlength="15" value="<%= data("custPhone1") %>" required>
            </div>
        </div>  
        <div class="row">
            <div class="col-lg-6 mb-3">
                <label for="typet" class="col-form-label">Type Transaksi</label>
                <select class="form-select" aria-label="Default select example" name="typet" id="typet" required>
                    <option value="<%= data("custtypetransaksi") %>">
                        <% if data("custTypetransaksi") = 1 then%>
                            CBD
                        <% elseif data("custTypetransaksi") = 2 then%>
                            COD
                        <% elseif data("custTypetransaksi") = 3 then%>
                            TOP
                        <% else %>
                        <% end if %>
                    </option>
                    <option value="1">CBD</option>
                    <option value="2">COD</option>
                    <option value="3">TOP</option>
                </select>
            </div>
            <div class="col-lg-6 mb-3">
                <label for="kdakun" class="col-form-label">Kode Akun</label>
                <select class="form-select" aria-label="Default select example" id="kdakun" name="kdakun">
                    <option value="<%= data("custKodeAkun") %>"><%= data("CA_Name") %></option>
                    <% do while not dataakun.eof %>
                    <option value="<%= dataakun("CA_ID") %>"><%= dataakun("CA_Name") %></option>
                    <% 
                    Response.flush
                    dataakun.movenext
                    loop
                    %>
                </select>
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
                    <option value="<%= data("custBankID") %>"><%= data("bank") %></option>
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
                <input type="number" maxlength="20" class="form-control" id="norek" name="norek" autocomplete="off" value="<%= data("custNorek") %>" >
            </div>
        </div>
        <div class="row ">
            <div class="col-lg-6 mb-3">
                <label for="rekName" class="form-label">Nama Pemilik Rekening</label>
                <input type="text" class="form-control" id="rekName" name="rekName" maxlength="50" autocomplete="off" value="<%= data("custRekName") %>">
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