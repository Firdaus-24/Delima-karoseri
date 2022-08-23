<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_OrjulH SET OJH_AktifYN = 'N' WHERE OJH_ID = '"& id &"'")
        call alert("ORDER JUAL DENGAN ID "&id&" ", "berhasil non aktifkan", "success","outgoing.asp") 
call footer() 
%>