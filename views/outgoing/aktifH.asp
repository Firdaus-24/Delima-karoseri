<!--#include file="../../init.asp"-->
<% 
        id = trim(Request.QueryString("id"))
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_MaterialOutH SET MO_AktifYN = 'N' WHERE MO_ID = '"& id &"'")
        call alert("FAKTUR HEADER ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>