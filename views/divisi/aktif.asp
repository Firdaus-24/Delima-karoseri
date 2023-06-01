<!--#include file="../../init.asp"-->
<% 
        if session("HR2C") = false then
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE HRD_M_Divisi SET DivaktifYN = 'N' WHERE DivId = '"& id &"'")
        call alert("DIVISI ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>