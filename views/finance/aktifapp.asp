<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_AppPermintaan SET AppAktifYN = 'N' WHERE appId = '"& id &"'")
        call alert("APPROVE ID "&id&" ", "berhasil non aktifkan", "success","dappPermintaan.asp") 
call footer() 
%>