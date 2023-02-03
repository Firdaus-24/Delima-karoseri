<!--#include file="../../init.asp"-->
<% 
    if session("PR1") = false then
        Response.Redirect("../index.asp")
    end if
    call header("PURCHASE ORDER") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>PURCHES ORDER DASHBOARD</h3> 
        </div>
    </div>
</div>


<% call footer() %>