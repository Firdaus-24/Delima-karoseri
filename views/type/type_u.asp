<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_typeBarang.asp"-->
<%  
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_TypeBarang WHERE T_ID = '"& id &"' AND T_AktifYN = 'Y'"

    set data = data_cmd.execute   

    call header("Form TypeBarang") 
%>
<style>
    hr{
        border-top: 1px dashed #8c8b8b;
        margin: 10px 0;
    }
    fieldset{
        border-radius: 4px;
        background: #fbfeff;
        padding: 5px;
        border: 1px dotted rgba(4, 129, 177, 0.5);
        margin: 5px 0;
        display: block;
        margin-inline-start: 2px;
        margin-inline-end: 2px;
        padding-block-start: 0.35em;
        padding-inline-start: 0.75em;
        padding-inline-end: 0.75em;
        padding-block-end: 0.625em;
        min-inline-size: min-content;
    }
    legend{
        color: #0481b1;
        background: #fff;
        border: 1px dotted rgba(4, 129, 177, 0.5);
        padding: 5px 10px;
        text-transform: uppercase;
        font-family: Helvetica, sans-serif;
        font-weight: bold;
        text-align: center;
        display: block;
        /* margin: 0 auto; */
    }
</style>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg text-center">
            <h3>FORM UPDATE TYPE BARANG</h3>
        </div>
    </div>
    <hr class="mb-3">
    <form action="type_u.asp?id=<%= id %>" method="post" id="formtype" onsubmit="validasiForm(this,event,'Type Barang','warning')">
    <fieldset>
        <legend>UPDATE DATA TYPE <br> <%= id %></legend>
        <input type="hidden" class="form-control" id="id" name="id" autocomplete="off" value="<%= data("T_ID") %>" required>
        <div class="row ">
            <div class="col-lg-1 mb-3">
                <label for="nama" class="form-label">Nama</label>
            </div>
            <div class="col-lg-5 mb-3">
                <input type="text" class="form-control" id="nama" name="nama" maxlength="30" autocomplete="off" value="<%= data("T_Nama") %>" required>
            </div>
            <div class="col-lg-1 mb-3">
                <label for="keterangan" class="form-label">Keterangan</label>
            </div>
            <div class="col-lg-5 mb-3">
                <input type="text" class="form-control" id="keterangan" name="keterangan" maxlength="50" autocomplete="off" value="<%= data("T_Keterangan") %>" required>
            </div>
        </div>
        <div class="row text-center">
            <div class="col-lg-12">
                <button type="submit" class="btn btn-primary">Update</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </fieldset>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateTypeBarang()
end if
call footer() 
%>