<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Kebutuhan.asp"-->
<%  
    if session("HR3B") = false then
        Response.Redirect("index.asp")
    end if
call header("Form departement") %>
<!--#include file="../../navbar.asp"-->
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateDep()
    if value = 1 then
        call alert("MASTER DEPARTEMENT", "berhasil di Update", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER DEPARTEMENT", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>