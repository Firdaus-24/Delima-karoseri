<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_divisi.asp"-->
<%  
    if session("HR2B") = false then
        Response.Redirect("index.asp")
    end if
call header("Form Divisi") %>
<!--#include file="../../navbar.asp"-->
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call UpdateDivisi()
    if value = 1 then
        call alert("MASTER DIVISI", "berhasil di Update", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER DIVISI", "tidak terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>