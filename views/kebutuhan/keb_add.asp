<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_kebutuhan.asp"-->
<%  call header("Form kebutuhan") %>
<!--#include file="../../navbar.asp"-->
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahKeb()
    if value = 1 then
        call alert("MASTER KEBUTUHAN PERMINTAAN", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("MASTER KEBUTUHAN PERMINTAAN", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>