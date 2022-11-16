<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_InvPemH SET IPH_AktifYN = 'N' WHERE IPH_ID = '"& id &"'")
        call alert("PURCHASE ORDER DENGAN ID "&id&" ", "berhasil non aktifkan", "success","incomming.asp") 
call footer() 
%>