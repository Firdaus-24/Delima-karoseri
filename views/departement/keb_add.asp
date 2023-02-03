<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_kebutuhan.asp"-->
<%  
    if session("HR3A") = false then
        Response.Redirect("index.asp")
    end if
call header("Form departement") %>
<!--#include file="../../navbar.asp"-->
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahDep()
    if value = 1 then
        call alert("MASTER DEPARTEMENT PERMINTAAN", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER DEPARTEMENT PERMINTAAN", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>