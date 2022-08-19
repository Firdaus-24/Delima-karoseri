<!--#include file="../../init.asp"-->
<% 
    set stok_cmd =  Server.CreateObject ("ADODB.Command")
    stok_cmd.ActiveConnection = mm_delima_string

    stok_cmd.commandText = ""

    
    call header("Inventory") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg-12">
            <h3>WELCOME TO INVENTORY</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg-12">

        </div>
    </div>
</div>
<% call footer() %>