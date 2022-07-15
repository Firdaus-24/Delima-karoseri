<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_Divisi SET DivaktifYN = 'N' WHERE DivId = '"& id &"'")
        call alert("DIVISI ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>