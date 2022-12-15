<!--#include file="../../init.asp"-->
<% 
        id = trim(Request.QueryString("id"))
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_InvJulH SET IJH_AktifYN = 'N' WHERE IJH_ID = '"& id &"'")
        call alert("FAKTUR HEADER ID "&id&" ", "berhasil non aktifkan", "success","jbarang.asp?id="&id) 
call footer() 
%>